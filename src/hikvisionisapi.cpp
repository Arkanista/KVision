#include "hikvisionisapi.h"
#include "hikvisionmanager.h"
#include <QNetworkProxy>
#include <QNetworkRequest>
#include <QPointer>
#include <QSet>
#include <QTimer>
#include <QUrl>
#include <QXmlStreamReader>
#include <QDebug>
#ifndef QT_NO_SSL
#include <QSslError>
#endif
#include <algorithm>
#include <cstring>

HikvisionISAPI::HikvisionISAPI(QObject *parent)
    : QObject(parent)
{
    m_netManager = new QNetworkAccessManager(this);
    m_netManager->setProxy(QNetworkProxy::NoProxy);
    connect(m_netManager, &QNetworkAccessManager::authenticationRequired,
            this, &HikvisionISAPI::onAuthenticationRequired);
#ifndef QT_NO_SSL
    connect(m_netManager, &QNetworkAccessManager::sslErrors,
            this, [](QNetworkReply *reply, const QList<QSslError> &) {
        if (reply) {
            reply->ignoreSslErrors();
        }
    });
#endif
}

HikvisionISAPI::~HikvisionISAPI()
{
    ++m_cancelGen;
    cancelAllSearches();

    std::lock_guard<std::mutex> lock(m_sdkThreadsMutex);
    for (QThread *thread : m_sdkSearchThreads) {
        thread->disconnect(this);
        thread->wait();
    }
    m_sdkSearchThreads.clear();
}

void HikvisionISAPI::searchRecordings(const QVariantMap &recorderInfo, int channelId, const QDateTime &start, const QDateTime &end)
{
    QString sessionId = QUuid::createUuid().toString();
    HikvisionSearchSession session;
    session.recorderInfo = recorderInfo;
    session.channelId = channelId;
    session.startTime = start;
    session.endTime = end;
    session.isMonthSearch = false;
    session.year = 0;
    session.month = 0;
    session.currentPosition = 1;
    m_sessions[sessionId] = session;

    doSearchRequest(sessionId);
}

void HikvisionISAPI::searchMonthAvailability(const QVariantMap &recorderInfo, int channelId, int year, int month)
{
    QString sessionId = QUuid::createUuid().toString();
    HikvisionSearchSession session;
    session.recorderInfo = recorderInfo;
    session.channelId = channelId;

    QDate firstDay(year, month, 1);
    QDate lastDay(year, month, firstDay.daysInMonth());

    session.startTime = QDateTime(firstDay, QTime(0, 0, 0), Qt::LocalTime);
    session.endTime = QDateTime(lastDay, QTime(23, 59, 59), Qt::LocalTime);
    session.isMonthSearch = true;
    session.year = year;
    session.month = month;
    session.currentPosition = 1;
    m_sessions[sessionId] = session;

    doSearchRequest(sessionId);
}

void HikvisionISAPI::doSearchRequest(const QString &sessionId)
{
    if (!m_sessions.contains(sessionId)) return;
    const HikvisionSearchSession &session = m_sessions[sessionId];

    const QString ip = HikvisionManager::sanitizeHost(session.recorderInfo.value(QStringLiteral("ip")).toString());
    int port = session.recorderInfo.contains(QStringLiteral("httpPort"))
             ? session.recorderInfo.value(QStringLiteral("httpPort")).toInt()
             : 80;
    if (port <= 0) port = 80;

    const QString endpointKey = QStringLiteral("%1:%2").arg(ip).arg(port);
    const qint64 nowMs = QDateTime::currentMSecsSinceEpoch();
    if (session.currentPosition == 1 && m_unreachableHttpEndpoints.contains(endpointKey)) {
        if (nowMs - m_unreachableHttpEndpoints.value(endpointKey) < 60000) {
            const HikvisionSearchSession copiedSession = session;
            m_sessions.remove(sessionId);
            searchViaSdkFallback(copiedSession, QStringLiteral("HTTP port cached as unreachable"));
            return;
        }
        m_unreachableHttpEndpoints.remove(endpointKey);
    }

    m_currentUser = session.recorderInfo.value(QStringLiteral("username")).toString();
    m_currentPassword = session.recorderInfo.value(QStringLiteral("password")).toString();

    const QString scheme = (port == 443 || port == 8443) ? QStringLiteral("https") : QStringLiteral("http");
    const QString hostStr = ip.contains(QLatin1Char(':')) ? QStringLiteral("[%1]").arg(ip) : ip;
    QUrl url(QStringLiteral("%1://%2:%3/ISAPI/ContentMgmt/search").arg(scheme, hostStr).arg(port));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, QStringLiteral("application/xml"));
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute, QNetworkRequest::NoLessSafeRedirectPolicy);

    QString startTimeStr = session.startTime.toUTC().toString(QStringLiteral("yyyy-MM-ddThh:mm:ss")) + QLatin1Char('Z');
    QString endTimeStr = session.endTime.toUTC().toString(QStringLiteral("yyyy-MM-ddThh:mm:ss")) + QLatin1Char('Z');

    qDebug() << "[ISAPI] doSearchRequest session:" << sessionId
             << "channelId:" << session.channelId
             << "startTime (orig):" << session.startTime.toString(Qt::ISODate)
             << "startTime (local):" << session.startTime.toLocalTime().toString(Qt::ISODate)
             << "startTimeStr:" << startTimeStr
             << "endTimeStr:" << endTimeStr
             << "pos:" << session.currentPosition;

    QString xmlPayload = QStringLiteral(
        "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
        "<CMSearchDescription xmlns=\"http://www.hikvision.com/ver20/XMLSchema\">\n"
        "  <searchID>%1</searchID>\n"
        "  <trackList>\n"
        "    <trackID>%2</trackID>\n"
        "  </trackList>\n"
        "  <timeSpanList>\n"
        "    <timeSpan>\n"
        "      <startTime>%3</startTime>\n"
        "      <endTime>%4</endTime>\n"
        "    </timeSpan>\n"
        "  </timeSpanList>\n"
        "  <maxResults>1000</maxResults>\n"
        "  <searchResultPostion>%5</searchResultPostion>\n"
        "  <metadataList>\n"
        "    <metadataDescriptor>//recordType.meta.std-cgi.com</metadataDescriptor>\n"
        "  </metadataList>\n"
        "</CMSearchDescription>\n"
    ).arg(sessionId).arg(session.channelId * 100 + 1).arg(startTimeStr, endTimeStr).arg(session.currentPosition);

    QNetworkReply *reply = m_netManager->post(request, xmlPayload.toUtf8());
    reply->setProperty("sessionId", sessionId);
    reply->setProperty("username", m_currentUser);
    reply->setProperty("password", m_currentPassword);
    reply->setProperty("endpointKey", endpointKey);

    const bool isRemote = session.recorderInfo.value(QStringLiteral("remoteRecorder"), false).toBool();
    QTimer *timeoutTimer = new QTimer(reply);
    timeoutTimer->setSingleShot(true);
    connect(timeoutTimer, &QTimer::timeout, reply, [reply]() {
        if (reply->isRunning()) {
            reply->abort();
        }
    });
    timeoutTimer->start(isRemote ? 8000 : 4500);

    m_activeReplies[sessionId] = reply;
    connect(reply, &QNetworkReply::finished, this, &HikvisionISAPI::onReplyFinished);
}

void HikvisionISAPI::onAuthenticationRequired(QNetworkReply *reply, QAuthenticator *authenticator)
{
    if (reply) {
        const int tries = reply->property("authAttempts").toInt();
        if (tries >= 1) {
            return;
        }
        reply->setProperty("authAttempts", tries + 1);
        QString user = reply->property("username").toString();
        QString pass = reply->property("password").toString();
        if (!user.isEmpty()) {
            authenticator->setUser(user);
            authenticator->setPassword(pass);
            return;
        }
    }
    authenticator->setUser(m_currentUser);
    authenticator->setPassword(m_currentPassword);
}

void HikvisionISAPI::onReplyFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    if (!reply) return;

    QString sessionId = reply->property("sessionId").toString();
    const QString endpointKey = reply->property("endpointKey").toString();
    m_activeReplies.remove(sessionId);
    reply->deleteLater();

    if (!m_sessions.contains(sessionId)) {
        return; // Session cancelled or already finished
    }

    HikvisionSearchSession session = m_sessions[sessionId];
    QString recorderIp = session.recorderInfo.value(QStringLiteral("ip")).toString();

    if (reply->error() != QNetworkReply::NoError) {
        const int httpStatus = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        qWarning() << "[ISAPI] HTTP Search failed:" << reply->errorString() << "(HTTP status:" << httpStatus << ")";
        m_sessions.remove(sessionId);

        if (httpStatus == 401 || httpStatus == 403) {
            // Do not trigger SDK login fallback on explicit HTTP authentication failure (prevents Illegal Login Lock)
            if (session.isMonthSearch) {
                emit monthAvailabilityFinished(recorderIp, session.channelId, session.year, session.month, QVariantList(), false);
            } else {
                emit searchFailed(recorderIp, session.channelId, session.startTime, reply->errorString());
            }
            return;
        }

        if (httpStatus == 0 && !endpointKey.isEmpty()) {
            m_unreachableHttpEndpoints.insert(endpointKey, QDateTime::currentMSecsSinceEpoch());
        }

        if (session.accumulatedSegments.isEmpty() && session.accumulatedDays.isEmpty()) {
            searchViaSdkFallback(session, reply->errorString());
            return;
        }

        if (session.isMonthSearch) {
            QVariantList daysList;
            for (int d : session.accumulatedDays) daysList.append(d);
            emit monthAvailabilityFinished(recorderIp, session.channelId, session.year, session.month, daysList, !daysList.isEmpty());
        } else {
            emit searchFinished(recorderIp, session.channelId, session.startTime, session.accumulatedSegments);
        }
        return;
    }

    if (!endpointKey.isEmpty()) {
        m_unreachableHttpEndpoints.remove(endpointKey);
    }

    HikvisionSearchSession &activeSession = m_sessions[sessionId];
    QByteArray response = reply->readAll();
    QXmlStreamReader xml(response);

    bool inMatchList = false;
    bool inMatchItem = false;
    QString responseStatusStrg;

    QDateTime currentStart;
    QDateTime currentEnd;

    int matchItemsCount = 0;

    while (!xml.atEnd() && !xml.hasError()) {
        QXmlStreamReader::TokenType token = xml.readNext();

        if (token == QXmlStreamReader::StartElement) {
            QString name = xml.name().toString();
            if (name == QLatin1String("responseStatusStrg")) {
                responseStatusStrg = xml.readElementText().trimmed();
            } else if (name == QLatin1String("matchList")) {
                inMatchList = true;
            } else if (inMatchList && name == QLatin1String("searchMatchItem")) {
                inMatchItem = true;
                matchItemsCount++;
            } else if (inMatchItem && name == QLatin1String("startTime")) {
                QString val = xml.readElementText();
                currentStart = QDateTime::fromString(val, Qt::ISODate).toLocalTime();
            } else if (inMatchItem && name == QLatin1String("endTime")) {
                QString val = xml.readElementText();
                currentEnd = QDateTime::fromString(val, Qt::ISODate).toLocalTime();
            }
        } else if (token == QXmlStreamReader::EndElement) {
            QString name = xml.name().toString();
            if (name == QLatin1String("matchList")) {
                inMatchList = false;
            } else if (name == QLatin1String("searchMatchItem")) {
                inMatchItem = false;
                if (currentStart.isValid() && currentEnd.isValid()) {
                    if (activeSession.isMonthSearch) {
                        int day = currentStart.date().day();
                        if (!activeSession.accumulatedDays.contains(day)) {
                            activeSession.accumulatedDays.append(day);
                        }
                    } else {
                        QVariantMap segment;
                        segment[QStringLiteral("startTime")] = currentStart.toMSecsSinceEpoch();
                        segment[QStringLiteral("endTime")] = currentEnd.toMSecsSinceEpoch();
                        activeSession.accumulatedSegments.append(segment);
                    }
                }
                currentStart = QDateTime();
                currentEnd = QDateTime();
            }
        }
    }

    if (xml.hasError()) {
        qWarning() << "[ISAPI] XML parsing error:" << xml.errorString();
        const HikvisionSearchSession copied = activeSession;
        m_sessions.remove(sessionId);
        if (copied.accumulatedSegments.isEmpty() && copied.accumulatedDays.isEmpty()) {
            searchViaSdkFallback(copied, xml.errorString());
            return;
        }
        if (copied.isMonthSearch) {
            QVariantList daysList;
            for (int d : copied.accumulatedDays) daysList.append(d);
            emit monthAvailabilityFinished(recorderIp, copied.channelId, copied.year, copied.month, daysList, false);
        } else {
            emit searchFailed(recorderIp, copied.channelId, copied.startTime, xml.errorString());
        }
        return;
    }

    if (matchItemsCount == 0) {
        if (activeSession.isMonthSearch) {
            QVariantList daysList;
            for (int d : activeSession.accumulatedDays) {
                daysList.append(d);
            }
            qDebug() << "[ISAPI] Month availability finished (no more matches) for channel:" << activeSession.channelId << "days:" << daysList;
            emit monthAvailabilityFinished(recorderIp, activeSession.channelId, activeSession.year, activeSession.month, daysList, true);
        } else {
            qDebug() << "[ISAPI] Day search finished (no more matches) for channel:" << activeSession.channelId << "segments:" << activeSession.accumulatedSegments.count();
            emit searchFinished(recorderIp, activeSession.channelId, activeSession.startTime, activeSession.accumulatedSegments);
        }
        m_sessions.remove(sessionId);
        return;
    }

    if (responseStatusStrg == QLatin1String("MORE") && activeSession.currentPosition < 100000) {
        qDebug() << "[ISAPI] Session" << sessionId << "status MORE; paginating next page from:" << (activeSession.currentPosition + matchItemsCount);
        activeSession.currentPosition += matchItemsCount;
        doSearchRequest(sessionId);
    } else {
        if (activeSession.isMonthSearch) {
            QVariantList daysList;
            for (int d : activeSession.accumulatedDays) {
                daysList.append(d);
            }
            qDebug() << "[ISAPI] Month availability finished for channel:" << activeSession.channelId << "days:" << daysList;
            emit monthAvailabilityFinished(recorderIp, activeSession.channelId, activeSession.year, activeSession.month, daysList, true);
        } else {
            qDebug() << "[ISAPI] Day search finished for channel:" << activeSession.channelId << "segments:" << activeSession.accumulatedSegments.count();
            emit searchFinished(recorderIp, activeSession.channelId, activeSession.startTime, activeSession.accumulatedSegments);
        }
        m_sessions.remove(sessionId);
    }
}

void HikvisionISAPI::searchViaSdkFallback(const HikvisionSearchSession &session, const QString &fallbackReason)
{
    const QString rawIp = session.recorderInfo.value(QStringLiteral("ip")).toString();
    const QString cleanIp = HikvisionManager::sanitizeHost(rawIp);
    int sdkPort = session.recorderInfo.value(QStringLiteral("sdkPort"),
                  session.recorderInfo.value(QStringLiteral("port"), 8000)).toInt();
    if (sdkPort <= 0) {
        sdkPort = 8000;
    }
    const QString user = session.recorderInfo.value(QStringLiteral("username")).toString();
    const QString pass = session.recorderInfo.value(QStringLiteral("password")).toString();
    const int channelId = session.channelId;
    const QDateTime startTime = session.startTime;
    const QDateTime endTime = session.endTime;
    const bool isMonthSearch = session.isMonthSearch;
    const int year = session.year;
    const int month = session.month;
    const uint64_t expectedGen = m_cancelGen.load();

    if (!HikvisionManager::instance() || cleanIp.isEmpty()) {
        if (isMonthSearch) {
            emit monthAvailabilityFinished(rawIp, channelId, year, month, QVariantList(), false);
        } else {
            emit searchFailed(rawIp, channelId, startTime, fallbackReason);
        }
        return;
    }

    qDebug() << "[ISAPI -> SDK Fallback] Querying recordings via NET_DVR_FindFile_V40 on" << cleanIp << ":" << sdkPort
             << "channel:" << channelId << "reason:" << fallbackReason;

    QPointer<HikvisionISAPI> self(this);
    QThread *thread = QThread::create([this, self, rawIp, cleanIp, sdkPort, user, pass, channelId,
                                       startTime, endTime, isMonthSearch, year, month, expectedGen, fallbackReason]() {
        HikvisionManager *mgr = HikvisionManager::instance();
        if (!mgr || m_cancelGen.load() != expectedGen) {
            return;
        }

        NET_DVR_DEVICEINFO_V40 devInfo;
        std::memset(&devInfo, 0, sizeof(devInfo));
        const LONG userId = mgr->loginShared(cleanIp, sdkPort, user, pass, devInfo);
        if (userId < 0) {
            if (self && m_cancelGen.load() == expectedGen) {
                QMetaObject::invokeMethod(self, [self, rawIp, channelId, startTime, isMonthSearch, year, month, fallbackReason]() {
                    if (!self) return;
                    if (isMonthSearch) {
                        emit self->monthAvailabilityFinished(rawIp, channelId, year, month, QVariantList(), false);
                    } else {
                        emit self->searchFailed(rawIp, channelId, startTime, fallbackReason);
                    }
                }, Qt::QueuedConnection);
            }
            return;
        }

        int realSdkChannel = channelId;
        const int chanNum = devInfo.struDeviceV30.byChanNum;
        const int ipChanNum = static_cast<int>(devInfo.struDeviceV30.byIPChanNum)
                            + (static_cast<int>(devInfo.struDeviceV30.byHighDChanNum) << 8);
        const int startDChan = devInfo.struDeviceV30.byStartDChan;
        const int startChan = devInfo.struDeviceV30.byStartChan > 0 ? devInfo.struDeviceV30.byStartChan : 1;

        if (chanNum == 0 && ipChanNum > 0 && startDChan > 0 && channelId < startDChan) {
            realSdkChannel = channelId + startDChan - 1;
        } else if (chanNum > 0 && channelId > chanNum && startDChan > 0 && channelId < startDChan) {
            realSdkChannel = startDChan + (channelId - chanNum) - 1;
        } else if (chanNum > 0 && channelId <= chanNum) {
            realSdkChannel = channelId + startChan - 1;
        }

        const QDateTime localStart = startTime.toLocalTime();
        const QDateTime localEnd = endTime.toLocalTime();

        NET_DVR_FILECOND_V40 cond;
        std::memset(&cond, 0, sizeof(cond));
        cond.lChannel = static_cast<LONG>(realSdkChannel);
        cond.dwFileType = 0xff;
        cond.dwIsLocked = 0xff;
        cond.struStartTime.dwYear = static_cast<DWORD>(localStart.date().year());
        cond.struStartTime.dwMonth = static_cast<DWORD>(localStart.date().month());
        cond.struStartTime.dwDay = static_cast<DWORD>(localStart.date().day());
        cond.struStartTime.dwHour = static_cast<DWORD>(localStart.time().hour());
        cond.struStartTime.dwMinute = static_cast<DWORD>(localStart.time().minute());
        cond.struStartTime.dwSecond = static_cast<DWORD>(localStart.time().second());

        cond.struStopTime.dwYear = static_cast<DWORD>(localEnd.date().year());
        cond.struStopTime.dwMonth = static_cast<DWORD>(localEnd.date().month());
        cond.struStopTime.dwDay = static_cast<DWORD>(localEnd.date().day());
        cond.struStopTime.dwHour = static_cast<DWORD>(localEnd.time().hour());
        cond.struStopTime.dwMinute = static_cast<DWORD>(localEnd.time().minute());
        cond.struStopTime.dwSecond = static_cast<DWORD>(localEnd.time().second());

        QVariantList segments;
        QSet<int> daysSet;
        bool queryOk = false;

        const LONG findHandle = NET_DVR_FindFile_V40(userId, &cond);
        if (findHandle >= 0) {
            queryOk = true;
            NET_DVR_FINDDATA_V40 findData;
            int safetyCount = 0;
            while (m_cancelGen.load() == expectedGen && safetyCount < 100000) {
                std::memset(&findData, 0, sizeof(findData));
                const LONG res = NET_DVR_FindNextFile_V40(findHandle, &findData);
                if (res == NET_DVR_ISFINDING) {
                    QThread::msleep(5);
                    continue;
                }
                if (res == NET_DVR_FILE_SUCCESS) {
                    ++safetyCount;
                    const auto &st = findData.struStartTime;
                    const auto &et = findData.struStopTime;
                    if (isMonthSearch) {
                        const QDate sDate(static_cast<int>(st.dwYear), static_cast<int>(st.dwMonth), static_cast<int>(st.dwDay));
                        const QDate eDate(static_cast<int>(et.dwYear), static_cast<int>(et.dwMonth), static_cast<int>(et.dwDay));
                        if (sDate.isValid()) {
                            QDate cur = sDate;
                            const QDate endCap = (eDate.isValid() && eDate >= sDate) ? eDate : sDate;
                            while (cur <= endCap) {
                                if (cur.year() == year && cur.month() == month) {
                                    daysSet.insert(cur.day());
                                }
                                cur = cur.addDays(1);
                            }
                        }
                    } else {
                        // Match ISAPI XML timestamp convention (wall-clock encoded in UTC epoch, shifted to local time in QML)
                        const QDateTime sDt(QDate(static_cast<int>(st.dwYear), static_cast<int>(st.dwMonth), static_cast<int>(st.dwDay)),
                                            QTime(static_cast<int>(st.dwHour), static_cast<int>(st.dwMinute), static_cast<int>(st.dwSecond)),
                                            Qt::UTC);
                        const QDateTime eDt(QDate(static_cast<int>(et.dwYear), static_cast<int>(et.dwMonth), static_cast<int>(et.dwDay)),
                                            QTime(static_cast<int>(et.dwHour), static_cast<int>(et.dwMinute), static_cast<int>(et.dwSecond)),
                                            Qt::UTC);
                        if (sDt.isValid() && eDt.isValid()) {
                            QVariantMap seg;
                            seg.insert(QStringLiteral("startTime"), sDt.toMSecsSinceEpoch());
                            seg.insert(QStringLiteral("endTime"), eDt.toMSecsSinceEpoch());
                            segments.append(seg);
                        }
                    }
                    continue;
                }
                if (res == NET_DVR_NOMOREFILE || res == NET_DVR_FILE_NOFIND) {
                    break;
                }
                qWarning() << "[ISAPI -> SDK Fallback] NET_DVR_FindNextFile_V40 stopped with code:" << res;
                break;
            }
            NET_DVR_FindClose_V30(findHandle);
        } else {
            qWarning() << "[ISAPI -> SDK Fallback] NET_DVR_FindFile_V40 failed with error:" << NET_DVR_GetLastError();
        }

        mgr->logoutShared(cleanIp);

        if (self && m_cancelGen.load() == expectedGen) {
            QList<int> sortedDays = daysSet.values();
            std::sort(sortedDays.begin(), sortedDays.end());
            QVariantList daysList;
            for (int d : sortedDays) {
                daysList.append(d);
            }

            QMetaObject::invokeMethod(self, [self, rawIp, channelId, startTime, isMonthSearch, year, month,
                                             queryOk, segments, daysList, fallbackReason]() {
                if (!self) return;
                if (isMonthSearch) {
                    qDebug() << "[ISAPI -> SDK Fallback] Month availability finished for channel:" << channelId << "days:" << daysList;
                    emit self->monthAvailabilityFinished(rawIp, channelId, year, month, daysList, queryOk);
                } else if (queryOk) {
                    qDebug() << "[ISAPI -> SDK Fallback] Day search finished for channel:" << channelId << "segments:" << segments.count();
                    emit self->searchFinished(rawIp, channelId, startTime, segments);
                } else {
                    emit self->searchFailed(rawIp, channelId, startTime, fallbackReason);
                }
            }, Qt::QueuedConnection);
        }
    });

    {
        std::lock_guard<std::mutex> lock(m_sdkThreadsMutex);
        m_sdkSearchThreads.append(thread);
    }

    connect(thread, &QThread::finished, this, [this, thread]() {
        std::lock_guard<std::mutex> lock(m_sdkThreadsMutex);
        m_sdkSearchThreads.removeOne(thread);
    });
    connect(thread, &QThread::finished, thread, &QThread::deleteLater);
    thread->start();
}

void HikvisionISAPI::cancelAllSearches()
{
    qDebug() << "[ISAPI] cancelAllSearches called. Cancelling" << m_sessions.size() << "active search sessions.";
    ++m_cancelGen;
    m_sessions.clear();

    QList<QNetworkReply*> repliesToAbort = m_activeReplies.values();
    m_activeReplies.clear();

    for (auto* reply : repliesToAbort) {
        if (reply) {
            reply->disconnect(this);
            reply->abort();
            reply->deleteLater();
        }
    }
}
