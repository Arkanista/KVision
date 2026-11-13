#include "hikvisionmanager.h"
#include "context.h"
#include <QAuthenticator>
#include <QDateTime>
#include <QDebug>
#include <QElapsedTimer>
#include <QEventLoop>
#include <QMap>
#include <QNetworkAccessManager>
#include <QNetworkProxy>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QRegularExpression>
#include <QRegularExpressionMatchIterator>
#include <QTcpSocket>
#include <QThread>
#include <QTimer>
#include <QUrl>
#ifndef QT_NO_SSL
#include <QSslError>
#endif
#include <algorithm>
#include <cstring>

HikvisionManager* HikvisionManager::m_instance = nullptr;

HikvisionManager::HikvisionManager(QObject *parent)
    : QObject(parent)
    , m_initialized(false)
{
    m_instance = this;

    std::thread initThread([this]() {
        if (NET_DVR_Init()) {
            NET_DVR_SetConnectTime(5000, 2);
            NET_DVR_SetReconnect(10000, TRUE);
            m_initialized = true;
            qDebug() << "[Hikvision] HCNetSDK Initialized successfully in background.";
        } else {
            qWarning() << "[Hikvision] Failed to initialize HCNetSDK.";
        }
        {
            std::lock_guard<std::mutex> lock(m_initMutex);
            m_initCompleted = true;
        }
        m_initCond.notify_all();
    });
    initThread.detach();

    // Start background worker thread for PTZ and keyframe commands
    m_ptzWorker = std::thread(&HikvisionManager::ptzWorkerLoop, this);
}

HikvisionManager::~HikvisionManager()
{
    // Wait for all active async discovery / port probe threads to finish
    {
        std::lock_guard<std::mutex> lock(m_discoveryMutex);
        for (QThread *thread : m_discoveryThreads) {
            thread->disconnect(this);
            thread->wait();
        }
        m_discoveryThreads.clear();
    }

    // Stop the worker thread cleanly first
    {
        std::lock_guard<std::mutex> lock(m_ptzMutex);
        m_ptzWorkerStop = true;
    }
    m_ptzCond.notify_all();
    if (m_ptzWorker.joinable()) {
        m_ptzWorker.join();
    }

    ensureInitialized();

    // Logout all active sessions
    for (auto it = m_sessions.begin(); it != m_sessions.end(); ++it) {
        NET_DVR_Logout(it.value().lUserID);
    }
    m_sessions.clear();

    for (auto it = m_sharedSessions.begin(); it != m_sharedSessions.end(); ++it) {
        NET_DVR_Logout(it.value().lUserID);
    }
    m_sharedSessions.clear();

    if (m_initialized) {
        NET_DVR_Cleanup();
        qDebug() << "[Hikvision] HCNetSDK Cleaned up.";
    }
    m_instance = nullptr;
}

HikvisionManager* HikvisionManager::instance()
{
    return m_instance;
}

QString HikvisionManager::sanitizeHost(const QString &rawIp)
{
    QString s = rawIp.trimmed();
    const int schemeIdx = s.indexOf(QLatin1String("://"));
    if (schemeIdx >= 0) {
        s = s.mid(schemeIdx + 3);
    }
    const int slashIdx = s.indexOf(QLatin1Char('/'));
    if (slashIdx >= 0) {
        s = s.left(slashIdx);
    }
    const int atIdx = s.lastIndexOf(QLatin1Char('@'));
    if (atIdx >= 0) {
        s = s.mid(atIdx + 1);
    }
    if (s.startsWith(QLatin1Char('['))) {
        const int closeBracket = s.indexOf(QLatin1Char(']'));
        if (closeBracket > 1) {
            return s.mid(1, closeBracket - 1).trimmed();
        }
    } else if (s.count(QLatin1Char(':')) == 1) {
        s = s.section(QLatin1Char(':'), 0, 0);
    }
    return s.trimmed();
}

int HikvisionManager::probeTcpPort(const QString &ip, int port, int timeoutMs)
{
    const QString cleanHost = sanitizeHost(ip);
    if (cleanHost.isEmpty() || port <= 0 || port > 65535) {
        return -1;
    }

    QTcpSocket socket;
    socket.setProxy(QNetworkProxy::NoProxy);
    QElapsedTimer timer;
    timer.start();
    socket.connectToHost(cleanHost, static_cast<quint16>(port));
    if (socket.waitForConnected(timeoutMs)) {
        const int elapsed = qMax(1, static_cast<int>(timer.elapsed()));
        socket.disconnectFromHost();
        return elapsed;
    }
    socket.abort();
    return -1;
}

static QByteArray fetchIsapiSingleScheme(const QString &scheme,
                                         const QString &ip,
                                         int port,
                                         const QString &username,
                                         const QString &password,
                                         const QString &path,
                                         int timeoutMs,
                                         int *httpStatusOut = nullptr)
{
    QNetworkAccessManager nam;
    nam.setProxy(QNetworkProxy::NoProxy);

    int authAttempts = 0;
    QObject::connect(&nam, &QNetworkAccessManager::authenticationRequired,
                     [&](QNetworkReply *, QAuthenticator *auth) {
        if (authAttempts++ == 0) {
            auth->setUser(username);
            auth->setPassword(password);
        }
    });
#ifndef QT_NO_SSL
    QObject::connect(&nam, &QNetworkAccessManager::sslErrors,
                     [](QNetworkReply *reply, const QList<QSslError> &) {
        if (reply) {
            reply->ignoreSslErrors();
        }
    });
#endif

    const QString hostStr = ip.contains(QLatin1Char(':')) ? QStringLiteral("[%1]").arg(ip) : ip;
    const QUrl url(QStringLiteral("%1://%2:%3%4").arg(scheme, hostStr).arg(port).arg(path));
    qDebug() << "[Hikvision ISAPI] Querying:" << url.toString();

    QNetworkRequest req(url);
    req.setHeader(QNetworkRequest::UserAgentHeader, QStringLiteral("KVision/2.7"));
    req.setAttribute(QNetworkRequest::RedirectPolicyAttribute, QNetworkRequest::NoLessSafeRedirectPolicy);

    QEventLoop loop;
    QTimer timer;
    timer.setSingleShot(true);

    QNetworkReply *reply = nam.get(req);
    QObject::connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    QObject::connect(&timer, &QTimer::timeout, &loop, [&]() {
        if (reply && reply->isRunning()) {
            reply->abort();
        }
        loop.quit();
    });

    timer.start(timeoutMs);
    loop.exec();
    timer.stop();

    const int httpStatus = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    if (httpStatusOut) {
        *httpStatusOut = httpStatus;
    }

    QByteArray body;
    if (reply->error() == QNetworkReply::NoError || (httpStatus >= 200 && httpStatus < 300)) {
        body = reply->readAll();
    }
    delete reply;
    return body;
}

static QByteArray fetchUrl(const QString &ip,
                           int port,
                           const QString &username,
                           const QString &password,
                           const QString &path,
                           int timeoutMs = 4000,
                           int *finalHttpStatusOut = nullptr)
{
    const bool preferHttps = (port == 443 || port == 8443);
    const QString firstScheme = preferHttps ? QStringLiteral("https") : QStringLiteral("http");
    const QString secondScheme = preferHttps ? QStringLiteral("http") : QStringLiteral("https");

    int httpStatus = 0;
    QByteArray res = fetchIsapiSingleScheme(firstScheme, ip, port, username, password, path, timeoutMs, &httpStatus);
    if (finalHttpStatusOut) {
        *finalHttpStatusOut = httpStatus;
    }
    if (!res.isEmpty() || httpStatus == 401 || httpStatus == 403) {
        return res;
    }

    // Retry with alternate scheme if no HTTP status or TLS/redirect mismatch (301/302/307/308/400)
    if (httpStatus == 0 || httpStatus == 400 || httpStatus == 301 || httpStatus == 302 || httpStatus == 307 || httpStatus == 308) {
        int secondStatus = 0;
        res = fetchIsapiSingleScheme(secondScheme, ip, port, username, password, path, timeoutMs, &secondStatus);
        if (finalHttpStatusOut && secondStatus != 0) {
            *finalHttpStatusOut = secondStatus;
        }
    }
    return res;
}

static QString decodeSdkChannelName(const BYTE *rawName, size_t maxLen)
{
    size_t len = 0;
    while (len < maxLen && rawName[len] != 0) {
        ++len;
    }
    if (len == 0) {
        return QString();
    }
    const QByteArray bytes(reinterpret_cast<const char *>(rawName), static_cast<int>(len));
    QString str = QString::fromUtf8(bytes).trimmed();
    if (str.contains(QChar::ReplacementCharacter)) {
        str = QString::fromLocal8Bit(bytes).trimmed();
    }
    return str;
}

static int translateLogicalToSdkChannel(int logicalChannelId, const NET_DVR_DEVICEINFO_V40 &deviceInfo)
{
    const int startDChan = deviceInfo.struDeviceV30.byStartDChan;
    const int chanNum = deviceInfo.struDeviceV30.byChanNum;
    const int startChan = deviceInfo.struDeviceV30.byStartChan > 0 ? deviceInfo.struDeviceV30.byStartChan : 1;

    if (startDChan > 0 && logicalChannelId < startDChan) {
        if (logicalChannelId <= chanNum) {
            return startChan + logicalChannelId - 1;
        }
        return startDChan + (logicalChannelId - chanNum) - 1;
    }
    return logicalChannelId;
}

QVariantList HikvisionManager::discoverCameras(const QString &ip,
                                               int port,
                                               int httpPort,
                                               const QString &username,
                                               const QString &password,
                                               bool remoteRecorder)
{
    QVariantList cameraList;
    QSet<int> seenChannels;

    const QString cleanIp = sanitizeHost(ip);
    if (cleanIp.isEmpty()) {
        return cameraList;
    }

    if (httpPort <= 0) {
        httpPort = 80;
    }
    if (port <= 0) {
        port = 8000;
    }

    const int tcpProbeMs = remoteRecorder ? 2200 : 1200;
    const int isapiTimeoutMs = remoteRecorder ? 8000 : 4000;

    int activeHttpPort = httpPort;
    bool httpPortOpen = (probeTcpPort(cleanIp, activeHttpPort, tcpProbeMs) >= 0);
    if (!httpPortOpen && activeHttpPort != 80 && !remoteRecorder) {
        if (probeTcpPort(cleanIp, 80, 900) >= 0) {
            activeHttpPort = 80;
            httpPortOpen = true;
        }
    }

    if (httpPortOpen) {
        qDebug() << "[Hikvision] Attempting NVR HTTP ISAPI discovery on" << cleanIp << "port" << activeHttpPort;

        int statusAnalog = 0;
        const QByteArray xmlAnalog = fetchUrl(cleanIp, activeHttpPort, username, password,
                                              QStringLiteral("/ISAPI/System/Video/inputs/channels"), isapiTimeoutMs, &statusAnalog);
        if (statusAnalog == 401) {
            qWarning() << "[Hikvision ISAPI] Authentication rejected (HTTP 401) on" << cleanIp
                       << "- stopping further login attempts to prevent Hikvision Illegal Login Lock.";
            return cameraList;
        }

        int statusIP = 0;
        const QByteArray xmlIP = fetchUrl(cleanIp, activeHttpPort, username, password,
                                          QStringLiteral("/ISAPI/ContentMgmt/InputProxy/channels"), isapiTimeoutMs, &statusIP);
        if (statusIP == 401) {
            qWarning() << "[Hikvision ISAPI] Authentication rejected (HTTP 401) on InputProxy — aborting.";
            return cameraList;
        }

        int statusStream = 0;
        const QByteArray xmlStreaming = fetchUrl(cleanIp, activeHttpPort, username, password,
                                                 QStringLiteral("/ISAPI/Streaming/channels"), isapiTimeoutMs, &statusStream);
        if (statusStream == 401) {
            qWarning() << "[Hikvision ISAPI] Authentication rejected (HTTP 401) on Streaming — aborting.";
            return cameraList;
        }

        QMap<int, QString> streamingNames;
        QList<int> streamingOrder;
        if (!xmlStreaming.isEmpty()) {
            QRegularExpression rxStream(QStringLiteral("<StreamingChannel[^>]*>([\\s\\S]*?)</StreamingChannel>"));
            QRegularExpression rxId(QStringLiteral("<id>(\\d+)</id>"));
            QRegularExpression rxName(QStringLiteral("<channelName>(.*?)</channelName>"));
            QRegularExpression rxEnabled(QStringLiteral("<enabled>(.*?)</enabled>"));

            QRegularExpressionMatchIterator iStream = rxStream.globalMatch(QString::fromUtf8(xmlStreaming));
            while (iStream.hasNext()) {
                const QString channelXml = iStream.next().captured(1);
                const int rawId = rxId.match(channelXml).captured(1).toInt();
                const QString name = rxName.match(channelXml).captured(1).trimmed();
                const QString enabled = rxEnabled.match(channelXml).captured(1).trimmed();

                if (rawId > 0 && enabled.compare(QLatin1String("false"), Qt::CaseInsensitive) != 0) {
                    const int baseChanId = (rawId >= 100) ? (rawId / 100) : rawId;
                    const int streamIdx = (rawId >= 100) ? (rawId % 100) : 1;
                    if (!streamingNames.contains(baseChanId)) {
                        streamingNames.insert(baseChanId, name);
                        streamingOrder.append(baseChanId);
                    } else if (streamIdx == 1 && !name.isEmpty()) {
                        streamingNames[baseChanId] = name;
                    }
                }
            }
        }

        int maxAnalogInputId = 0;
        QMap<int, QString> analogChannels;
        if (!xmlAnalog.isEmpty()) {
            QRegularExpression rxChan(QStringLiteral("<VideoInputChannel[^>]*>([\\s\\S]*?)</VideoInputChannel>"));
            QRegularExpression rxId(QStringLiteral("<id>(\\d+)</id>"));
            QRegularExpression rxName(QStringLiteral("<name>(.*?)</name>"));
            QRegularExpression rxChanName(QStringLiteral("<channelName>(.*?)</channelName>"));
            QRegularExpression rxEnabled(QStringLiteral("<videoInputEnabled>(.*?)</videoInputEnabled>"));

            QRegularExpressionMatchIterator iChan = rxChan.globalMatch(QString::fromUtf8(xmlAnalog));
            while (iChan.hasNext()) {
                const QString channelXml = iChan.next().captured(1);
                const int id = rxId.match(channelXml).captured(1).toInt();
                QString name = rxName.match(channelXml).captured(1).trimmed();
                if (name.isEmpty()) {
                    name = rxChanName.match(channelXml).captured(1).trimmed();
                }
                const QString enabled = rxEnabled.match(channelXml).captured(1).trimmed();

                if (id > maxAnalogInputId) {
                    maxAnalogInputId = id;
                }
                if (id > 0 && enabled.compare(QLatin1String("false"), Qt::CaseInsensitive) != 0) {
                    analogChannels.insert(id, name);
                }
            }
        }

        QList<QPair<int, QString>> ipChannels;
        if (!xmlIP.isEmpty()) {
            QRegularExpression rxIP(QStringLiteral("<InputProxyChannel[^>]*>([\\s\\S]*?)</InputProxyChannel>"));
            QRegularExpression rxId(QStringLiteral("<id>(\\d+)</id>"));
            QRegularExpression rxName(QStringLiteral("<name>(.*?)</name>"));
            QRegularExpression rxChanName(QStringLiteral("<channelName>(.*?)</channelName>"));

            QRegularExpressionMatchIterator iIP = rxIP.globalMatch(QString::fromUtf8(xmlIP));
            while (iIP.hasNext()) {
                const QString channelXml = iIP.next().captured(1);
                const int id = rxId.match(channelXml).captured(1).toInt();
                QString name = rxName.match(channelXml).captured(1).trimmed();
                if (name.isEmpty()) {
                    name = rxChanName.match(channelXml).captured(1).trimmed();
                }
                if (id > 0) {
                    ipChannels.append(qMakePair(id, name));
                }
            }
        }

        // 1. Add enabled Analog/TVI channels (1 .. maxAnalogInputId)
        for (auto it = analogChannels.constBegin(); it != analogChannels.constEnd(); ++it) {
            const int id = it.key();
            if (!seenChannels.contains(id)) {
                seenChannels.insert(id);
                QString name = it.value();
                if (name.isEmpty()) {
                    name = streamingNames.value(id);
                }
                QVariantMap cam;
                cam.insert(QStringLiteral("channelId"), id);
                cam.insert(QStringLiteral("name"), name.isEmpty() ? QStringLiteral("Camera %1").arg(id) : name);
                cam.insert(QStringLiteral("recorderIp"), cleanIp);
                cameraList.append(cam);
                qDebug() << "[Hikvision ISAPI] Discovered analog channel:" << id << "name:" << name;
            }
        }

        // 2. Add IP Proxy channels (offset by maxAnalogInputId on Hybrid DVRs so IDs match RTSP /Streaming/Channels/X01)
        for (const auto &ipEntry : ipChannels) {
            const int rawIpId = ipEntry.first;
            int resolvedChanId = rawIpId;
            if (maxAnalogInputId > 0) {
                if (rawIpId <= maxAnalogInputId) {
                    resolvedChanId = maxAnalogInputId + rawIpId;
                } else if (rawIpId >= 33 && !streamingNames.isEmpty()
                           && !streamingNames.contains(rawIpId)
                           && streamingNames.contains(maxAnalogInputId + (rawIpId - 32))) {
                    resolvedChanId = maxAnalogInputId + (rawIpId - 32);
                }
            } else if (rawIpId >= 33 && !streamingNames.isEmpty()
                       && !streamingNames.contains(rawIpId)
                       && streamingNames.contains(rawIpId - 32)) {
                resolvedChanId = rawIpId - 32;
            }

            if (resolvedChanId > 0 && !seenChannels.contains(resolvedChanId)) {
                seenChannels.insert(resolvedChanId);
                QString name = ipEntry.second;
                if (name.isEmpty()) {
                    name = streamingNames.value(resolvedChanId);
                }
                QVariantMap cam;
                cam.insert(QStringLiteral("channelId"), resolvedChanId);
                cam.insert(QStringLiteral("name"), name.isEmpty() ? QStringLiteral("Camera %1").arg(resolvedChanId) : name);
                cam.insert(QStringLiteral("recorderIp"), cleanIp);
                cameraList.append(cam);
                qDebug() << "[Hikvision ISAPI] Discovered IP proxy channel:" << resolvedChanId << "(raw ID:" << rawIpId << ") name:" << name;
            }
        }

        // 3. Fallback or supplement from /ISAPI/Streaming/channels
        if (cameraList.isEmpty() && !streamingOrder.isEmpty()) {
            for (int baseChanId : streamingOrder) {
                if (!seenChannels.contains(baseChanId)) {
                    seenChannels.insert(baseChanId);
                    const QString name = streamingNames.value(baseChanId);
                    QVariantMap cam;
                    cam.insert(QStringLiteral("channelId"), baseChanId);
                    cam.insert(QStringLiteral("name"), name.isEmpty() ? QStringLiteral("Camera %1").arg(baseChanId) : name);
                    cam.insert(QStringLiteral("recorderIp"), cleanIp);
                    cameraList.append(cam);
                    qDebug() << "[Hikvision ISAPI] Discovered streaming channel:" << baseChanId << "name:" << name;
                }
            }
        }

        if (!cameraList.isEmpty()) {
            // Refresh SDK session in background if SDK port is reachable so deviceInfo & green status badge reflect current credentials
            if (probeTcpPort(cleanIp, port, remoteRecorder ? 1800 : 800) >= 0) {
                logout(cleanIp);
                getSession(cleanIp, port, username, password);
            }
            return cameraList;
        }
    } else {
        qDebug() << "[Hikvision] HTTP port" << activeHttpPort << "on" << cleanIp
                 << "is unreachable; skipping ISAPI HTTP probes and going directly to SDK port" << port;
    }

    ensureInitialized();
    if (!m_initialized) {
        qWarning() << "[Hikvision] Cannot login: SDK not initialized.";
        return cameraList;
    }

    // Logout from previous session on same IP if any
    logout(cleanIp);

    NET_DVR_USER_LOGIN_INFO loginInfo;
    std::memset(&loginInfo, 0, sizeof(NET_DVR_USER_LOGIN_INFO));

    std::strncpy(loginInfo.sDeviceAddress, cleanIp.toUtf8().constData(), sizeof(loginInfo.sDeviceAddress) - 1);
    loginInfo.wPort = static_cast<WORD>(port);
    std::strncpy(loginInfo.sUserName, username.toUtf8().constData(), sizeof(loginInfo.sUserName) - 1);
    std::strncpy(loginInfo.sPassword, password.toUtf8().constData(), sizeof(loginInfo.sPassword) - 1);
    loginInfo.bUseAsynLogin = FALSE;
    loginInfo.byLoginMode = 0; // Private mode

    NET_DVR_DEVICEINFO_V40 deviceInfo;
    std::memset(&deviceInfo, 0, sizeof(NET_DVR_DEVICEINFO_V40));

    LONG lUserID = NET_DVR_Login_V40(&loginInfo, &deviceInfo);
    if (lUserID < 0) {
        const DWORD err = NET_DVR_GetLastError();
        qWarning() << "[Hikvision] SDK Login failed for IP:" << cleanIp << "port:" << port << "Error:" << err;
        return cameraList;
    }

    bool wasLogged = false;
    bool isLoggedNow = false;
    {
        std::lock_guard<std::mutex> lock(m_sharedSessionsMutex);
        wasLogged = isLoggedInternal(cleanIp);
        m_sessions.insert(cleanIp, {lUserID, port, deviceInfo});
        isLoggedNow = isLoggedInternal(cleanIp);
    }
    qDebug() << "[Hikvision] Logged in successfully to IP:" << cleanIp << "port:" << port << "UserID:" << lUserID;
    if (wasLogged != isLoggedNow) {
        emit sessionStatusChanged(cleanIp, isLoggedNow);
    }

    const int analogChanCount = deviceInfo.struDeviceV30.byChanNum;
    const int startAnalogChan = deviceInfo.struDeviceV30.byStartChan > 0 ? deviceInfo.struDeviceV30.byStartChan : 1;
    const int totalIpChanCount = static_cast<int>(deviceInfo.struDeviceV30.byIPChanNum)
                               + (static_cast<int>(deviceInfo.struDeviceV30.byHighDChanNum) << 8);
    const int startDChan = deviceInfo.struDeviceV30.byStartDChan > 0 ? deviceInfo.struDeviceV30.byStartDChan : 33;

    qDebug() << "[Hikvision SDK Discovery] Device capabilities — Analog:" << analogChanCount
             << "(start:" << startAnalogChan << "), Max IP:" << totalIpChanCount
             << "(startDChan:" << startDChan << ")";

    bool picCfgV40Supported = true;
    bool picCfgV30Supported = true;
    auto querySdkChannelName = [&](LONG sdkChan) -> QString {
        if (picCfgV40Supported) {
            NET_DVR_PICCFG_V40 picV40;
            std::memset(&picV40, 0, sizeof(picV40));
            DWORD bytesRet = 0;
            if (NET_DVR_GetDVRConfig(lUserID, NET_DVR_GET_PICCFG_V40, sdkChan, &picV40, sizeof(picV40), &bytesRet)) {
                return decodeSdkChannelName(picV40.sChanName, NAME_LEN);
            }
            const DWORD err = NET_DVR_GetLastError();
            if (err == NET_DVR_NOSUPPORT || err == NET_DVR_COMMANDTIMEOUT || err == NET_DVR_NOENOUGHPRI) {
                picCfgV40Supported = false;
            }
        }
        if (picCfgV30Supported) {
            NET_DVR_PICCFG_V30 picV30;
            std::memset(&picV30, 0, sizeof(picV30));
            DWORD bytesRet = 0;
            if (NET_DVR_GetDVRConfig(lUserID, NET_DVR_GET_PICCFG_V30, sdkChan, &picV30, sizeof(picV30), &bytesRet)) {
                return decodeSdkChannelName(picV30.sChanName, NAME_LEN);
            }
            const DWORD err = NET_DVR_GetLastError();
            if (err == NET_DVR_NOSUPPORT || err == NET_DVR_COMMANDTIMEOUT || err == NET_DVR_NOENOUGHPRI) {
                picCfgV30Supported = false;
            }
        }
        return QString();
    };

    NET_DVR_IPPARACFG_V40 ipParaCfg;
    std::memset(&ipParaCfg, 0, sizeof(NET_DVR_IPPARACFG_V40));
    DWORD bytesReturned = 0;
    const BOOL getCfgRet = NET_DVR_GetDVRConfig(lUserID, NET_DVR_GET_IPPARACFG_V40, 0,
                                                &ipParaCfg, sizeof(NET_DVR_IPPARACFG_V40), &bytesReturned);

    // 1. Discover Analog / Coax BNC channels on DVRs and Hybrid DVRs
    if (analogChanCount > 0) {
        const int maxAnalog = qMin(analogChanCount, static_cast<int>(MAX_CHANNUM_V30));
        for (int i = 0; i < maxAnalog; ++i) {
            if (!getCfgRet || ipParaCfg.byAnalogChanEnable[i] != 0) {
                const int logicalChanId = startAnalogChan + i;
                if (!seenChannels.contains(logicalChanId)) {
                    seenChannels.insert(logicalChanId);
                    const QString osdName = querySdkChannelName(static_cast<LONG>(logicalChanId));
                    QVariantMap cam;
                    cam.insert(QStringLiteral("channelId"), logicalChanId);
                    cam.insert(QStringLiteral("name"), osdName.isEmpty() ? QStringLiteral("Camera %1").arg(logicalChanId) : osdName);
                    cam.insert(QStringLiteral("recorderIp"), cleanIp);
                    cameraList.append(cam);
                    qDebug() << "[Hikvision SDK] Discovered analog/coax channel:" << logicalChanId << "name:" << osdName;
                }
            }
        }
    }

    // 2. Discover Digital / IP channels on Pure NVRs and Hybrid DVRs
    if (getCfgRet) {
        const int maxGroups = (totalIpChanCount > static_cast<int>(MAX_IP_DEVICE_V40))
                            ? ((totalIpChanCount + static_cast<int>(MAX_IP_DEVICE_V40) - 1) / static_cast<int>(MAX_IP_DEVICE_V40))
                            : 1;

        for (int group = 0; group < maxGroups; ++group) {
            NET_DVR_IPPARACFG_V40 groupCfg;
            if (group == 0) {
                groupCfg = ipParaCfg;
            } else {
                std::memset(&groupCfg, 0, sizeof(NET_DVR_IPPARACFG_V40));
                DWORD groupBytes = 0;
                if (!NET_DVR_GetDVRConfig(lUserID, NET_DVR_GET_IPPARACFG_V40, static_cast<DWORD>(group),
                                          &groupCfg, sizeof(NET_DVR_IPPARACFG_V40), &groupBytes)) {
                    break;
                }
            }

            const int groupOffset = group * static_cast<int>(MAX_IP_DEVICE_V40);
            DWORD groupDChanCount = groupCfg.dwDChanNum;
            if (groupDChanCount == 0 || groupDChanCount > MAX_IP_DEVICE_V40) {
                const int remaining = (totalIpChanCount > groupOffset) ? (totalIpChanCount - groupOffset) : static_cast<int>(MAX_IP_DEVICE_V40);
                groupDChanCount = static_cast<DWORD>(qMin(remaining, static_cast<int>(MAX_IP_DEVICE_V40)));
            }
            const int groupStartSdkChan = (groupCfg.dwStartDChan > 0)
                                        ? static_cast<int>(groupCfg.dwStartDChan)
                                        : (startDChan + groupOffset);

            for (DWORD i = 0; i < groupDChanCount; ++i) {
                if (groupCfg.struIPDevInfo[i].byEnable == 1) {
                    const int ipZeroBasedIdx = groupOffset + static_cast<int>(i);
                    // Logical RTSP channel ID: 1..N on pure NVR, (analogChanCount + 1).. on Hybrid DVR
                    const int logicalChanId = (analogChanCount > 0)
                                            ? (analogChanCount + ipZeroBasedIdx + 1)
                                            : (ipZeroBasedIdx + 1);
                    const LONG sdkChan = static_cast<LONG>(groupStartSdkChan + static_cast<int>(i));

                    if (!seenChannels.contains(logicalChanId)) {
                        seenChannels.insert(logicalChanId);
                        const QString osdName = querySdkChannelName(sdkChan);
                        QVariantMap cam;
                        cam.insert(QStringLiteral("channelId"), logicalChanId);
                        cam.insert(QStringLiteral("name"), osdName.isEmpty() ? QStringLiteral("Camera %1").arg(logicalChanId) : osdName);
                        cam.insert(QStringLiteral("recorderIp"), cleanIp);
                        cameraList.append(cam);
                        qDebug() << "[Hikvision SDK] Discovered IP channel — logical RTSP ID:" << logicalChanId
                                 << "SDK chan:" << sdkChan << "name:" << osdName;
                    }
                }
            }
        }
    } else if (analogChanCount == 0 && totalIpChanCount > 0) {
        // Fallback for pure NVRs that do not support NET_DVR_GET_IPPARACFG_V40
        for (int i = 0; i < totalIpChanCount; ++i) {
            const int logicalChanId = i + 1;
            const LONG sdkChan = static_cast<LONG>(startDChan + i);
            if (!seenChannels.contains(logicalChanId)) {
                seenChannels.insert(logicalChanId);
                const QString osdName = querySdkChannelName(sdkChan);
                QVariantMap cam;
                cam.insert(QStringLiteral("channelId"), logicalChanId);
                cam.insert(QStringLiteral("name"), osdName.isEmpty() ? QStringLiteral("Camera %1").arg(logicalChanId) : osdName);
                cam.insert(QStringLiteral("recorderIp"), cleanIp);
                cameraList.append(cam);
            }
        }
    }

    // Ultimate fallback if a device reported 0 active channels everywhere
    if (cameraList.isEmpty()) {
        const int fallbackCount = (totalIpChanCount > 0) ? qMin(totalIpChanCount, 16) : 4;
        for (int i = 0; i < fallbackCount; ++i) {
            const int chanId = i + 1;
            QVariantMap cam;
            cam.insert(QStringLiteral("channelId"), chanId);
            cam.insert(QStringLiteral("name"), QStringLiteral("Camera %1").arg(chanId));
            cam.insert(QStringLiteral("recorderIp"), cleanIp);
            cameraList.append(cam);
        }
    }

    return cameraList;
}

void HikvisionManager::discoverCamerasAsync(const QString &ip,
                                            int port,
                                            int httpPort,
                                            const QString &username,
                                            const QString &password,
                                            bool remoteRecorder)
{
    const QString cleanIp = sanitizeHost(ip);
    QThread *thread = QThread::create([this, cleanIp, port, httpPort, username, password, remoteRecorder]() {
        QVariantList cameras = discoverCameras(cleanIp, port, httpPort, username, password, remoteRecorder);
        bool success = !cameras.isEmpty();
        QString errorMsg = success ? QString() : tr("LNG_00099");
        emit discoveryFinished(cleanIp, cameras, success, errorMsg);
    });

    {
        std::lock_guard<std::mutex> lock(m_discoveryMutex);
        m_discoveryThreads.append(thread);
    }

    connect(thread, &QThread::finished, this, [this, thread]() {
        std::lock_guard<std::mutex> lock(m_discoveryMutex);
        m_discoveryThreads.removeOne(thread);
    });

    connect(thread, &QThread::finished, thread, &QThread::deleteLater);
    thread->start();
}

void HikvisionManager::testPortsAsync(const QString &ip, int sdkPort, int httpPort, int rtspPort)
{
    const QString cleanIp = sanitizeHost(ip);
    const int sPort = sdkPort > 0 ? sdkPort : 8000;
    const int hPort = httpPort > 0 ? httpPort : 80;
    const int rPort = rtspPort > 0 ? rtspPort : 554;

    QThread *thread = QThread::create([this, cleanIp, sPort, hPort, rPort]() {
        int sdkMs = -1;
        int httpMs = -1;
        int rtspMs = -1;

        std::thread tSdk([&]() { sdkMs = probeTcpPort(cleanIp, sPort, 2500); });
        std::thread tHttp([&]() { httpMs = probeTcpPort(cleanIp, hPort, 2500); });
        std::thread tRtsp([&]() { rtspMs = probeTcpPort(cleanIp, rPort, 2500); });

        tSdk.join();
        tHttp.join();
        tRtsp.join();

        {
            std::lock_guard<std::mutex> lock(m_discoveryMutex);
            const QString key = QStringLiteral("%1:%2").arg(cleanIp).arg(rPort);
            m_rtspCheckCache.insert(key, qMakePair(QDateTime::currentMSecsSinceEpoch(), rtspMs >= 0));
        }

        emit portsTestFinished(cleanIp, sdkMs >= 0, httpMs >= 0, rtspMs >= 0, sdkMs, httpMs, rtspMs);
        emit rtspPortChecked(cleanIp, rPort, rtspMs >= 0);
    });

    {
        std::lock_guard<std::mutex> lock(m_discoveryMutex);
        m_discoveryThreads.append(thread);
    }

    connect(thread, &QThread::finished, this, [this, thread]() {
        std::lock_guard<std::mutex> lock(m_discoveryMutex);
        m_discoveryThreads.removeOne(thread);
    });

    connect(thread, &QThread::finished, thread, &QThread::deleteLater);
    thread->start();
}

void HikvisionManager::checkRtspPortAsync(const QString &ip, int rtspPort)
{
    const QString cleanIp = sanitizeHost(ip);
    const int rPort = rtspPort > 0 ? rtspPort : 554;
    if (cleanIp.isEmpty()) {
        return;
    }

    const QString key = QStringLiteral("%1:%2").arg(cleanIp).arg(rPort);
    const qint64 nowMs = QDateTime::currentMSecsSinceEpoch();

    {
        std::lock_guard<std::mutex> lock(m_discoveryMutex);
        if (m_rtspCheckCache.contains(key)) {
            const auto cached = m_rtspCheckCache.value(key);
            if (nowMs - cached.first < 5000) {
                const bool cachedOpen = cached.second;
                QMetaObject::invokeMethod(this, [this, cleanIp, rPort, cachedOpen]() {
                    emit rtspPortChecked(cleanIp, rPort, cachedOpen);
                }, Qt::QueuedConnection);
                return;
            }
        }
        if (m_rtspCheckInFlight.contains(key)) {
            return;
        }
        m_rtspCheckInFlight.insert(key);
    }

    QThread *thread = QThread::create([this, cleanIp, rPort, key]() {
        const int ms = probeTcpPort(cleanIp, rPort, 2000);
        const bool isOpen = (ms >= 0);
        {
            std::lock_guard<std::mutex> lock(m_discoveryMutex);
            m_rtspCheckCache.insert(key, qMakePair(QDateTime::currentMSecsSinceEpoch(), isOpen));
            m_rtspCheckInFlight.remove(key);
        }
        emit rtspPortChecked(cleanIp, rPort, isOpen);
    });

    {
        std::lock_guard<std::mutex> lock(m_discoveryMutex);
        m_discoveryThreads.append(thread);
    }

    connect(thread, &QThread::finished, this, [this, thread]() {
        std::lock_guard<std::mutex> lock(m_discoveryMutex);
        m_discoveryThreads.removeOne(thread);
    });

    connect(thread, &QThread::finished, thread, &QThread::deleteLater);
    thread->start();
}

void HikvisionManager::logout(const QString &ip)
{
    const QString cleanIp = sanitizeHost(ip);
    LONG lUserID = -1;
    bool wasLogged = false;
    bool isLoggedNow = false;
    {
        std::lock_guard<std::mutex> lock(m_sharedSessionsMutex);
        wasLogged = isLoggedInternal(cleanIp);
        if (m_sessions.contains(cleanIp)) {
            lUserID = m_sessions.take(cleanIp).lUserID;
        }
        isLoggedNow = isLoggedInternal(cleanIp);
    }
    if (lUserID >= 0) {
        ensureInitialized();
        NET_DVR_Logout(lUserID);
        qDebug() << "[Hikvision] Logged out from IP:" << cleanIp << "UserID:" << lUserID;
    }
    if (wasLogged != isLoggedNow) {
        emit sessionStatusChanged(cleanIp, isLoggedNow);
    }
}

bool HikvisionManager::isLogged(const QString &ip)
{
    const QString cleanIp = sanitizeHost(ip);
    std::lock_guard<std::mutex> lock(m_sharedSessionsMutex);
    return isLoggedInternal(cleanIp);
}

bool HikvisionManager::isLoggedInternal(const QString &ip) const
{
    return m_sessions.contains(ip) || m_sharedSessions.contains(ip);
}

bool HikvisionManager::getDeviceInfo(const QString &ip, NET_DVR_DEVICEINFO_V40 &deviceInfo)
{
    const QString cleanIp = sanitizeHost(ip);
    std::lock_guard<std::mutex> lock(m_sharedSessionsMutex);
    if (m_sessions.contains(cleanIp)) {
        deviceInfo = m_sessions.value(cleanIp).deviceInfo;
        return true;
    }
    if (m_sharedSessions.contains(cleanIp)) {
        deviceInfo = m_sharedSessions.value(cleanIp).deviceInfo;
        return true;
    }
    return false;
}

LONG HikvisionManager::getSession(const QString &ip, int port, const QString &username, const QString &password)
{
    const QString cleanIp = sanitizeHost(ip);
    if (cleanIp.isEmpty()) {
        return -1;
    }
    if (port <= 0) {
        port = 8000;
    }

    bool wasLogged = false;
    bool isLoggedNow = false;
    LONG staleUserId = -1;

    // 1. Check if already logged in on the matching port
    {
        std::lock_guard<std::mutex> lock(m_sharedSessionsMutex);
        if (m_sessions.contains(cleanIp)) {
            const auto &existing = m_sessions.value(cleanIp);
            if (existing.port == port) {
                return existing.lUserID;
            }
            staleUserId = m_sessions.take(cleanIp).lUserID;
        } else if (m_sharedSessions.contains(cleanIp)) {
            const auto &existingShared = m_sharedSessions.value(cleanIp);
            if (existingShared.port == port) {
                return existingShared.lUserID;
            }
        }
        wasLogged = isLoggedInternal(cleanIp);
    }

    // 2. Not logged in (or port changed), log in
    ensureInitialized();

    if (staleUserId >= 0) {
        NET_DVR_Logout(staleUserId);
    }

    if (!m_initialized) {
        qWarning() << "[Hikvision] Cannot get session: SDK not initialized.";
        return -1;
    }

    NET_DVR_USER_LOGIN_INFO loginInfo;
    std::memset(&loginInfo, 0, sizeof(NET_DVR_USER_LOGIN_INFO));
    std::strncpy(loginInfo.sDeviceAddress, cleanIp.toUtf8().constData(), sizeof(loginInfo.sDeviceAddress) - 1);
    loginInfo.wPort = static_cast<WORD>(port);
    std::strncpy(loginInfo.sUserName, username.toUtf8().constData(), sizeof(loginInfo.sUserName) - 1);
    std::strncpy(loginInfo.sPassword, password.toUtf8().constData(), sizeof(loginInfo.sPassword) - 1);
    loginInfo.bUseAsynLogin = FALSE;
    loginInfo.byLoginMode = 0; // Private mode

    NET_DVR_DEVICEINFO_V40 deviceInfo;
    std::memset(&deviceInfo, 0, sizeof(NET_DVR_DEVICEINFO_V40));

    LONG lUserID = NET_DVR_Login_V40(&loginInfo, &deviceInfo);
    if (lUserID < 0) {
        DWORD err = NET_DVR_GetLastError();
        qWarning() << "[Hikvision] getSession login FAILED for IP:" << cleanIp << "port:" << port << "Error:" << err;
        return -1;
    }

    {
        std::lock_guard<std::mutex> lock(m_sharedSessionsMutex);
        m_sessions.insert(cleanIp, {lUserID, port, deviceInfo});
        isLoggedNow = isLoggedInternal(cleanIp);
    }

    qDebug() << "[Hikvision] getSession login SUCCESS for IP:" << cleanIp << "UserID:" << lUserID;
    if (wasLogged != isLoggedNow) {
        emit sessionStatusChanged(cleanIp, isLoggedNow);
    }

    return lUserID;
}

bool HikvisionManager::forceIFrame(const QString &ip,
                                   int port,
                                   const QString &username,
                                   const QString &password,
                                   int channelId,
                                   bool isSubStream)
{
    PtzCommand cmd;
    cmd.ip = sanitizeHost(ip);
    cmd.port = port > 0 ? port : 8000;
    cmd.username = username;
    cmd.password = password;
    cmd.channelId = channelId;
    cmd.isKeyFrame = true;
    cmd.isSubStream = isSubStream;

    if (cmd.ip.isEmpty()) {
        return false;
    }

    {
        std::lock_guard<std::mutex> lock(m_ptzMutex);
        m_ptzQueue.push(cmd);
    }
    m_ptzCond.notify_one();
    return true;
}

bool HikvisionManager::ptzZoom(const QString &ip, int port, const QString &username, const QString &password, int channelId, int command, bool stop)
{
    PtzCommand cmd;
    cmd.ip = sanitizeHost(ip);
    cmd.port = port > 0 ? port : 8000;
    cmd.username = username;
    cmd.password = password;
    cmd.channelId = channelId;
    cmd.command = command;
    cmd.stop = stop;
    cmd.isKeyFrame = false;

    {
        std::lock_guard<std::mutex> lock(m_ptzMutex);
        m_ptzQueue.push(cmd);
    }
    m_ptzCond.notify_one();
    return true;
}

void HikvisionManager::ptzWorkerLoop()
{
    while (true) {
        PtzCommand cmd;
        {
            std::unique_lock<std::mutex> lock(m_ptzMutex);
            m_ptzCond.wait(lock, [this]() { return m_ptzWorkerStop || !m_ptzQueue.empty(); });
            if (m_ptzWorkerStop && m_ptzQueue.empty()) {
                break;
            }
            cmd = m_ptzQueue.front();
            m_ptzQueue.pop();
        }

        LONG lUserID = getSession(cmd.ip, cmd.port, cmd.username, cmd.password);
        if (lUserID < 0) {
            qWarning() << "[Hikvision Worker] Failed to get session for IP:" << cmd.ip;
            continue;
        }

        NET_DVR_DEVICEINFO_V40 deviceInfo;
        int targetChannel = cmd.channelId;
        if (getDeviceInfo(cmd.ip, deviceInfo)) {
            targetChannel = translateLogicalToSdkChannel(cmd.channelId, deviceInfo);
        }

        if (cmd.isKeyFrame) {
            BOOL ret = cmd.isSubStream
                     ? NET_DVR_MakeKeyFrameSub(lUserID, static_cast<LONG>(targetChannel))
                     : NET_DVR_MakeKeyFrame(lUserID, static_cast<LONG>(targetChannel));
            if (!ret) {
                const DWORD err = NET_DVR_GetLastError();
                qDebug() << "[Hikvision Worker] MakeKeyFrame" << (cmd.isSubStream ? "(Sub)" : "(Main)")
                         << "returned false for IP:" << cmd.ip << "Channel:" << targetChannel << "Error:" << err;
            } else {
                qDebug() << "[Hikvision Worker] MakeKeyFrame" << (cmd.isSubStream ? "(Sub)" : "(Main)")
                         << "succeeded for IP:" << cmd.ip << "Channel:" << targetChannel;
            }
            continue;
        }

        DWORD dwStop = cmd.stop ? 1 : 0;
        BOOL ret = NET_DVR_PTZControl_Other(lUserID, static_cast<LONG>(targetChannel), static_cast<DWORD>(cmd.command), dwStop);
        if (!ret) {
            DWORD err = NET_DVR_GetLastError();
            qWarning() << "[Hikvision PTZ Worker] PTZ Control failed for IP:" << cmd.ip << "Channel:" << targetChannel
                       << "Command:" << cmd.command << "Stop:" << cmd.stop << "Error:" << err;
        } else {
            qDebug() << "[Hikvision PTZ Worker] PTZ Control succeeded for IP:" << cmd.ip << "Channel:" << targetChannel
                     << "Command:" << cmd.command << "Stop:" << cmd.stop;
        }
    }
}

LONG HikvisionManager::loginShared(const QString &ip, int port, const QString &username, const QString &password, NET_DVR_DEVICEINFO_V40 &deviceInfo)
{
    const QString cleanIp = sanitizeHost(ip);
    if (cleanIp.isEmpty()) {
        return -1;
    }
    if (port <= 0) {
        port = 8000;
    }

    bool wasLogged = false;
    bool isLoggedNow = false;
    LONG lUserID = -1;
    LONG staleSharedId = -1;

    {
        std::lock_guard<std::mutex> lock(m_sharedSessionsMutex);
        if (m_sharedSessions.contains(cleanIp)) {
            auto &session = m_sharedSessions[cleanIp];
            if (session.port == port) {
                session.refCount++;
                deviceInfo = session.deviceInfo;
                qDebug() << "[Hikvision Shared] Reusing session for IP:" << cleanIp << "UserID:" << session.lUserID << "RefCount:" << session.refCount;
                return session.lUserID;
            }
            staleSharedId = session.lUserID;
            m_sharedSessions.remove(cleanIp);
        }
        wasLogged = isLoggedInternal(cleanIp);
    }

    qDebug() << "[Hikvision Shared] Creating NEW session for IP:" << cleanIp << ":" << port;

    ensureInitialized();

    if (staleSharedId >= 0) {
        NET_DVR_Logout(staleSharedId);
    }

    if (!m_initialized) {
        qWarning() << "[Hikvision Shared] Cannot login: SDK not initialized.";
        return -1;
    }

    NET_DVR_USER_LOGIN_INFO loginInfo;
    std::memset(&loginInfo, 0, sizeof(NET_DVR_USER_LOGIN_INFO));
    std::strncpy(loginInfo.sDeviceAddress, cleanIp.toUtf8().constData(), sizeof(loginInfo.sDeviceAddress) - 1);
    loginInfo.wPort = static_cast<WORD>(port);
    std::strncpy(loginInfo.sUserName, username.toUtf8().constData(), sizeof(loginInfo.sUserName) - 1);
    std::strncpy(loginInfo.sPassword, password.toUtf8().constData(), sizeof(loginInfo.sPassword) - 1);
    loginInfo.bUseAsynLogin = FALSE;
    loginInfo.byLoginMode = 0;

    NET_DVR_DEVICEINFO_V40 devInfo;
    std::memset(&devInfo, 0, sizeof(NET_DVR_DEVICEINFO_V40));

    lUserID = NET_DVR_Login_V40(&loginInfo, &devInfo);
    if (lUserID < 0) {
        DWORD err = NET_DVR_GetLastError();
        qWarning() << "[Hikvision Shared] Login FAILED for IP:" << cleanIp << "port:" << port << "Error:" << err;
        return -1;
    }

    {
        std::lock_guard<std::mutex> lock(m_sharedSessionsMutex);
        SharedSession session;
        session.lUserID = lUserID;
        session.port = port;
        session.deviceInfo = devInfo;
        session.refCount = 1;

        m_sharedSessions.insert(cleanIp, session);
        deviceInfo = devInfo;
        isLoggedNow = isLoggedInternal(cleanIp);
    }

    qDebug() << "[Hikvision Shared] Login SUCCESS for IP:" << cleanIp << "UserID:" << lUserID;
    if (wasLogged != isLoggedNow) {
        emit sessionStatusChanged(cleanIp, isLoggedNow);
    }
    return lUserID;
}

void HikvisionManager::logoutShared(const QString &ip)
{
    const QString cleanIp = sanitizeHost(ip);
    bool wasLogged = false;
    bool isLoggedNow = false;
    LONG lUserIDToLogout = -1;

    {
        std::lock_guard<std::mutex> lock(m_sharedSessionsMutex);
        wasLogged = isLoggedInternal(cleanIp);
        if (m_sharedSessions.contains(cleanIp)) {
            auto &session = m_sharedSessions[cleanIp];
            session.refCount--;
            qDebug() << "[Hikvision Shared] Decremented refCount for IP:" << cleanIp << "New RefCount:" << session.refCount;
            if (session.refCount <= 0) {
                lUserIDToLogout = session.lUserID;
                m_sharedSessions.remove(cleanIp);
            }
        }
        isLoggedNow = isLoggedInternal(cleanIp);
    }

    if (lUserIDToLogout >= 0) {
        ensureInitialized();
        NET_DVR_Logout(lUserIDToLogout);
        qDebug() << "[Hikvision Shared] Logged out session for IP:" << cleanIp << "UserID:" << lUserIDToLogout;
    }

    if (wasLogged != isLoggedNow) {
        emit sessionStatusChanged(cleanIp, isLoggedNow);
    }
}

void HikvisionManager::forceLogoutShared(const QString &ip)
{
    const QString cleanIp = sanitizeHost(ip);
    bool wasLogged = false;
    bool isLoggedNow = false;
    LONG lUserIDToLogout = -1;

    {
        std::lock_guard<std::mutex> lock(m_sharedSessionsMutex);
        wasLogged = isLoggedInternal(cleanIp);
        if (m_sharedSessions.contains(cleanIp)) {
            auto &session = m_sharedSessions[cleanIp];
            lUserIDToLogout = session.lUserID;
            m_sharedSessions.remove(cleanIp);
            qDebug() << "[Hikvision Shared] Force logout requested. Removing session for IP:" << cleanIp << "UserID:" << lUserIDToLogout;
        }
        isLoggedNow = isLoggedInternal(cleanIp);
    }

    if (lUserIDToLogout >= 0) {
        ensureInitialized();
        NET_DVR_Logout(lUserIDToLogout);
        qDebug() << "[Hikvision Shared] Logged out session for IP (force):" << cleanIp << "UserID:" << lUserIDToLogout;
    }

    if (wasLogged != isLoggedNow) {
        emit sessionStatusChanged(cleanIp, isLoggedNow);
    }
}

void HikvisionManager::ensureInitialized() const
{
    std::unique_lock<std::mutex> lock(m_initMutex);
    m_initCond.wait(lock, [this]() { return m_initCompleted; });
}
