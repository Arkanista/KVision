#include "hikvisiondownloader.h"
#include "qmlav/src/qmlavdemuxer.h"
#include <QDebug>
#include <QThread>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QCoreApplication>
#include <QStandardPaths>
#include <QVector>

extern "C" {
#include <libavformat/avformat.h>
#include <libavcodec/avcodec.h>
#include <libavutil/avutil.h>
}

static qint64 getActualFileSize(const QString &filePath)
{
    if (filePath.isEmpty())
        return 0;
    QFile f(filePath);
    if (f.open(QIODevice::ReadOnly)) {
        qint64 sz = f.size();
        f.close();
        if (sz > 0)
            return sz;
    }
    QFileInfo fi(filePath);
    fi.refresh();
    return fi.exists() ? fi.size() : 0;
}

static QString resolveFfmpegExecutable()
{
    const QString appDir = QCoreApplication::applicationDirPath();
#ifdef _WIN32
    const QString bundledExe = QDir(appDir).filePath(QStringLiteral("ffmpeg.exe"));
    if (QFileInfo::exists(bundledExe)) {
        return bundledExe;
    }
#else
    const QString bundledBin = QDir(appDir).filePath(QStringLiteral("ffmpeg"));
    if (QFileInfo::exists(bundledBin)) {
        return bundledBin;
    }
#endif
    const QString fromPath = QStandardPaths::findExecutable(QStringLiteral("ffmpeg"));
    if (!fromPath.isEmpty()) {
        return fromPath;
    }
    return QStringLiteral("ffmpeg");
}

static bool remuxPsToMp4InProcess(const QString &inputPath, const QString &outputPath)
{
    AVFormatContext *inFmtCtx = nullptr;
    AVFormatContext *outFmtCtx = nullptr;
    AVPacket *pkt = av_packet_alloc();
    if (!pkt)
        return false;

    const QByteArray inBytes = QDir::toNativeSeparators(inputPath).toUtf8();
    const QByteArray outBytes = QDir::toNativeSeparators(outputPath).toUtf8();

    bool ok = false;
    do {
        if (avformat_open_input(&inFmtCtx, inBytes.constData(), nullptr, nullptr) < 0)
            break;
        inFmtCtx->flags |= AVFMT_FLAG_GENPTS;
        if (avformat_find_stream_info(inFmtCtx, nullptr) < 0)
            break;

        if (avformat_alloc_output_context2(&outFmtCtx, nullptr, "mp4", outBytes.constData()) < 0 || !outFmtCtx)
            break;

        QVector<int> streamMap(static_cast<int>(inFmtCtx->nb_streams), -1);
        int outStreamIdx = 0;

        for (unsigned int i = 0; i < inFmtCtx->nb_streams; ++i) {
            AVStream *inStream = inFmtCtx->streams[i];
            AVCodecParameters *inCodecPar = inStream->codecpar;
            bool copyStream = (inCodecPar->codec_type == AVMEDIA_TYPE_VIDEO) ||
                              (inCodecPar->codec_type == AVMEDIA_TYPE_AUDIO &&
                               (inCodecPar->codec_id == AV_CODEC_ID_AAC ||
                                inCodecPar->codec_id == AV_CODEC_ID_MP3 ||
                                inCodecPar->codec_id == AV_CODEC_ID_MP2));
            if (!copyStream)
                continue;

            AVStream *outStream = avformat_new_stream(outFmtCtx, nullptr);
            if (!outStream)
                break;
            if (avcodec_parameters_copy(outStream->codecpar, inCodecPar) < 0)
                break;
            outStream->codecpar->codec_tag = 0;
            outStream->time_base = inStream->time_base;
            streamMap[static_cast<int>(i)] = outStreamIdx++;
        }

        if (outStreamIdx == 0)
            break;

        if (!(outFmtCtx->oformat->flags & AVFMT_NOFILE)) {
            if (avio_open(&outFmtCtx->pb, outBytes.constData(), AVIO_FLAG_WRITE) < 0)
                break;
        }

        if (avformat_write_header(outFmtCtx, nullptr) < 0)
            break;

        QVector<int64_t> lastDts(outStreamIdx, AV_NOPTS_VALUE);
        int64_t packetCount = 0;

        while (av_read_frame(inFmtCtx, pkt) >= 0) {
            int inIdx = pkt->stream_index;
            if (inIdx < 0 || inIdx >= streamMap.size() || streamMap[inIdx] < 0) {
                av_packet_unref(pkt);
                continue;
            }
            int outIdx = streamMap[inIdx];
            AVStream *inStream = inFmtCtx->streams[inIdx];
            AVStream *outStream = outFmtCtx->streams[outIdx];

            pkt->stream_index = outIdx;
            av_packet_rescale_ts(pkt, inStream->time_base, outStream->time_base);

            if (pkt->dts == AV_NOPTS_VALUE) {
                pkt->dts = (lastDts[outIdx] != AV_NOPTS_VALUE) ? (lastDts[outIdx] + 1) : 0;
            }
            if (lastDts[outIdx] != AV_NOPTS_VALUE && pkt->dts <= lastDts[outIdx]) {
                pkt->dts = lastDts[outIdx] + 1;
            }
            if (pkt->pts == AV_NOPTS_VALUE || pkt->pts < pkt->dts) {
                pkt->pts = pkt->dts;
            }
            lastDts[outIdx] = pkt->dts;
            pkt->pos = -1;

            if (av_interleaved_write_frame(outFmtCtx, pkt) >= 0) {
                packetCount++;
            }
            av_packet_unref(pkt);
        }

        av_write_trailer(outFmtCtx);
        ok = (packetCount > 0);
    } while (false);

    av_packet_free(&pkt);
    if (inFmtCtx) {
        avformat_close_input(&inFmtCtx);
    }
    if (outFmtCtx) {
        if (!(outFmtCtx->oformat->flags & AVFMT_NOFILE) && outFmtCtx->pb) {
            avio_closep(&outFmtCtx->pb);
        }
        avformat_free_context(outFmtCtx);
    }
    if (!ok) {
        QFile::remove(outputPath);
    }
    return ok && (getActualFileSize(outputPath) > 0);
}

HikvisionDownloader::HikvisionDownloader(QObject *parent)
    : QObject(parent)
    , m_isDownloading(false)
    , m_isConverting(false)
    , m_progress(0)
    , m_statusText("")
    , m_lUserID(-1)
    , m_lFileHandle(-1)
{
    m_timer = new QTimer(this);
    m_timer->setInterval(1000);
    connect(m_timer, &QTimer::timeout, this, &HikvisionDownloader::checkProgress);

    m_ffmpegProcess = new QProcess(this);
    m_ffmpegProcess->setWorkingDirectory(QCoreApplication::applicationDirPath());
#ifdef _WIN32
    m_ffmpegProcess->setCreateProcessArgumentsModifier([](QProcess::CreateProcessArguments *args) {
        args->flags |= CREATE_NO_WINDOW;
    });
#endif
    connect(m_ffmpegProcess, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished), this, &HikvisionDownloader::onFfmpegFinished);
    connect(m_ffmpegProcess, &QProcess::errorOccurred, this, &HikvisionDownloader::onFfmpegError);
}

HikvisionDownloader::~HikvisionDownloader()
{
    // Ensure the search thread is interrupted and safely joined/deleted to prevent use-after-free crashes
    QThread* threadToWait = nullptr;
    {
        std::lock_guard<std::mutex> lock(m_searchMutex);
        if (m_searchThread) {
            threadToWait = m_searchThread;
            m_searchThread = nullptr;
        }
    }
    if (threadToWait) {
        threadToWait->requestInterruption();
        threadToWait->disconnect();
    }

    stopDownload();

    if (threadToWait) {
        threadToWait->wait();
        delete threadToWait;
    }
}

bool HikvisionDownloader::isDownloading() const
{
    return m_isDownloading;
}

bool HikvisionDownloader::isConverting() const
{
    return m_isConverting;
}

QString HikvisionDownloader::statusText() const
{
    return m_statusText;
}

int HikvisionDownloader::progress() const
{
    return m_progress;
}

int HikvisionDownloader::overallProgress() const
{
    if (m_totalSegmentsCount <= 0) return 0;
    return ((m_currentSegmentIndex * 100) + m_progress) / m_totalSegmentsCount;
}

void HikvisionDownloader::startDownload(const QVariantMap &recorderInfo, int channelId, const QDateTime &start, const QDateTime &end, const QString &saveFilePath)
{
    if (m_isDownloading) {
        emit downloadFinished(false, tr("LNG_00504"));
        return;
    }

    m_recorderInfo = recorderInfo;
    m_channelId = channelId;

    m_isDownloading = true;
    m_progress = 0;
    m_statusText = tr("LNG_00503");
    emit isDownloadingChanged();
    emit progressChanged();
    emit overallProgressChanged();
    emit statusTextChanged();

    QThread *thread = QThread::create([this, recorderInfo, channelId, start, end, saveFilePath]() {
        QString ip = recorderInfo["ip"].toString();
        int port = recorderInfo.contains("sdkPort") ? recorderInfo["sdkPort"].toInt() : recorderInfo["port"].toInt();
        if (port <= 0) port = 8000;
        QString username = recorderInfo["username"].toString();
        QString password = recorderInfo["password"].toString();

        NET_DVR_USER_LOGIN_INFO loginInfo;
        std::memset(&loginInfo, 0, sizeof(NET_DVR_USER_LOGIN_INFO));
        std::strncpy(loginInfo.sDeviceAddress, ip.toUtf8().constData(), sizeof(loginInfo.sDeviceAddress) - 1);
        loginInfo.wPort = static_cast<WORD>(port);
        std::strncpy(loginInfo.sUserName, username.toUtf8().constData(), sizeof(loginInfo.sUserName) - 1);
        std::strncpy(loginInfo.sPassword, password.toUtf8().constData(), sizeof(loginInfo.sPassword) - 1);

        NET_DVR_DEVICEINFO_V40 deviceInfo;
        std::memset(&deviceInfo, 0, sizeof(NET_DVR_DEVICEINFO_V40));

        LONG lUserID = NET_DVR_Login_V40(&loginInfo, &deviceInfo);
        if (lUserID < 0) {
            int err = NET_DVR_GetLastError();
            QMetaObject::invokeMethod(this, [this, err]() {
                m_isDownloading = false;
                emit isDownloadingChanged();
                emit downloadFinished(false, tr("LNG_00502").arg(err));
            });
            return;
        }

        int realSdkChannel = channelId;
        if (deviceInfo.struDeviceV30.byChanNum == 0 && deviceInfo.struDeviceV30.byIPChanNum > 0) {
            realSdkChannel = channelId + deviceInfo.struDeviceV30.byStartDChan - 1;
        } else if (deviceInfo.struDeviceV30.byChanNum > 0 && channelId > deviceInfo.struDeviceV30.byChanNum) {
            realSdkChannel = deviceInfo.struDeviceV30.byStartDChan + (channelId - deviceInfo.struDeviceV30.byChanNum) - 1;
        } else if (deviceInfo.struDeviceV30.byChanNum > 0 && channelId <= deviceInfo.struDeviceV30.byChanNum) {
            realSdkChannel = channelId + deviceInfo.struDeviceV30.byStartChan - 1;
        }

        // Find all physical recording files in this time range
        NET_DVR_FILECOND_V40 findCond;
        std::memset(&findCond, 0, sizeof(NET_DVR_FILECOND_V40));
        findCond.lChannel = static_cast<LONG>(realSdkChannel);
        findCond.dwFileType = 0xFF; // All types
        findCond.dwIsLocked = 0xFF; // All locks
        findCond.dwUseCardNo = 0;
        
        findCond.struStartTime.dwYear = start.date().year();
        findCond.struStartTime.dwMonth = start.date().month();
        findCond.struStartTime.dwDay = start.date().day();
        findCond.struStartTime.dwHour = start.time().hour();
        findCond.struStartTime.dwMinute = start.time().minute();
        findCond.struStartTime.dwSecond = start.time().second();

        findCond.struStopTime.dwYear = end.date().year();
        findCond.struStopTime.dwMonth = end.date().month();
        findCond.struStopTime.dwDay = end.date().day();
        findCond.struStopTime.dwHour = end.time().hour();
        findCond.struStopTime.dwMinute = end.time().minute();
        findCond.struStopTime.dwSecond = end.time().second();

        QList<DownloadSegment> foundSegments;
        LONG lFindHandle = NET_DVR_FindFile_V40(lUserID, &findCond);
        if (lFindHandle >= 0) {
            NET_DVR_FINDDATA_V50 findData;
            while (true) {
                if (QThread::currentThread()->isInterruptionRequested()) {
                    break;
                }
                int state = NET_DVR_FindNextFile_V50(lFindHandle, &findData);
                if (state == 1000) { // NET_DVR_FILE_SUCCESS
                    QDateTime fileStart(QDate(findData.struStartTime.wYear, findData.struStartTime.byMonth, findData.struStartTime.byDay),
                                        QTime(findData.struStartTime.byHour, findData.struStartTime.byMinute, findData.struStartTime.bySecond));
                    QDateTime fileEnd(QDate(findData.struStopTime.wYear, findData.struStopTime.byMonth, findData.struStopTime.byDay),
                                      QTime(findData.struStopTime.byHour, findData.struStopTime.byMinute, findData.struStopTime.bySecond));
                    
                    QDateTime intersectStart = fileStart > start ? fileStart : start;
                    QDateTime intersectEnd = fileEnd < end ? fileEnd : end;
                    
                    if (intersectStart < intersectEnd) {
                        DownloadSegment seg;
                        seg.startTime = intersectStart;
                        seg.endTime = intersectEnd;
                        foundSegments.append(seg);
                    }
                } else if (state == 1002) { // NET_DVR_ISFINDING
                    QThread::msleep(10);
                } else {
                    break;
                }
            }
            NET_DVR_FindClose_V30(lFindHandle);
        }

        // Post result back to main thread
        QMetaObject::invokeMethod(this, [this, lUserID, realSdkChannel, foundSegments, saveFilePath]() {
            if (!m_isDownloading) {
                // Download was stopped while searching! Logout and abort.
                NET_DVR_Logout(lUserID);
                return;
            }
            m_lUserID = lUserID;
            m_realSdkChannel = realSdkChannel;
            m_segments = foundSegments;

            if (m_segments.isEmpty()) {
                NET_DVR_Logout(m_lUserID);
                m_lUserID = -1;
                m_isDownloading = false;
                emit isDownloadingChanged();
                emit downloadFinished(false, tr("LNG_00501"));
                return;
            }

            // Sort segments chronologically
            std::sort(m_segments.begin(), m_segments.end(), [](const DownloadSegment &a, const DownloadSegment &b) {
                return a.startTime < b.startTime;
            });

            // Generate filenames for segments
            QString baseFinal = saveFilePath;
            QString baseTemp = saveFilePath;
            if (baseTemp.endsWith(".mp4", Qt::CaseInsensitive)) {
                baseTemp.replace(baseTemp.length() - 4, 4, ".pspart");
            }

            int totalParts = m_segments.size();
            int padWidth = 1;
            if (totalParts > 99) {
                padWidth = 3;
            } else if (totalParts > 9) {
                padWidth = 2;
            }

            for (int i = 0; i < totalParts; ++i) {
                QString segFinal = baseFinal;
                QString segTemp = baseTemp;
                if (totalParts > 1) {
                    int partNum = i + 1;
                    QString suffix = QString("_%1").arg(partNum, padWidth, 10, QChar('0'));
                    if (segFinal.endsWith(".mp4", Qt::CaseInsensitive)) {
                        segFinal.insert(segFinal.length() - 4, suffix);
                    } else {
                        segFinal += suffix;
                    }
                    if (segTemp.endsWith(".pspart", Qt::CaseInsensitive)) {
                        segTemp.insert(segTemp.length() - 7, suffix);
                    } else {
                        segTemp += suffix;
                    }
                }
                m_segments[i].finalPath = segFinal;
                m_segments[i].tempPath = segTemp;
            }

            m_currentSegmentIndex = 0;
            m_totalSegmentsCount = m_segments.size();
            m_convertedSegmentsCount = 0;

            startNextSegment();
        });
    });

    {
        std::lock_guard<std::mutex> lock(m_searchMutex);
        m_searchThread = thread;
    }

    connect(thread, &QThread::finished, this, [this, thread]() {
        std::lock_guard<std::mutex> lock(m_searchMutex);
        if (m_searchThread == thread) {
            m_searchThread = nullptr;
        }
    });
    connect(thread, &QThread::finished, thread, &QThread::deleteLater);
    thread->start();
}

void HikvisionDownloader::startNextSegment()
{
    if (m_currentSegmentIndex >= m_segments.size()) {
        m_isDownloading = false;
        emit isDownloadingChanged();
        
        NET_DVR_Logout(m_lUserID);
        m_lUserID = -1;
        
        QString summaryMsg = tr("LNG_00500").arg(m_convertedSegmentsCount).arg(m_totalSegmentsCount);
        m_statusText = summaryMsg;
        emit statusTextChanged();
        emit downloadFinished(true, summaryMsg);
        return;
    }

    const DownloadSegment &seg = m_segments.at(m_currentSegmentIndex);
    m_tempFilePath = seg.tempPath;
    m_finalFilePath = seg.finalPath;

    NET_DVR_PLAYCOND downloadCond;
    std::memset(&downloadCond, 0, sizeof(NET_DVR_PLAYCOND));
    downloadCond.dwChannel = static_cast<DWORD>(m_realSdkChannel);
    downloadCond.struStartTime.dwYear = seg.startTime.date().year();
    downloadCond.struStartTime.dwMonth = seg.startTime.date().month();
    downloadCond.struStartTime.dwDay = seg.startTime.date().day();
    downloadCond.struStartTime.dwHour = seg.startTime.time().hour();
    downloadCond.struStartTime.dwMinute = seg.startTime.time().minute();
    downloadCond.struStartTime.dwSecond = seg.startTime.time().second();

    downloadCond.struStopTime.dwYear = seg.endTime.date().year();
    downloadCond.struStopTime.dwMonth = seg.endTime.date().month();
    downloadCond.struStopTime.dwDay = seg.endTime.date().day();
    downloadCond.struStopTime.dwHour = seg.endTime.time().hour();
    downloadCond.struStopTime.dwMinute = seg.endTime.time().minute();
    downloadCond.struStopTime.dwSecond = seg.endTime.time().second();

    downloadCond.byStreamType = 0; // Main stream
    downloadCond.byCourseFile = 0;
    downloadCond.byDownload = 1;

    QFileInfo fileInfo(m_tempFilePath);
    QDir dir;
    if (!dir.mkpath(fileInfo.absolutePath())) {
        NET_DVR_Logout(m_lUserID);
        m_lUserID = -1;
        m_isDownloading = false;
        emit isDownloadingChanged();
        emit downloadFinished(false, tr("LNG_00499").arg(fileInfo.absolutePath()));
        return;
    }
    
    QFileInfo dirInfo(fileInfo.absolutePath());
    if (!dirInfo.isWritable()) {
        NET_DVR_Logout(m_lUserID);
        m_lUserID = -1;
        m_isDownloading = false;
        emit isDownloadingChanged();
        emit downloadFinished(false, tr("LNG_00498").arg(fileInfo.absolutePath()));
        return;
    }

    if (fileInfo.exists()) {
        QFile::remove(m_tempFilePath);
    }
    QByteArray pathBytes = QDir::toNativeSeparators(m_tempFilePath).toLocal8Bit();

    m_lFileHandle = NET_DVR_GetFileByTime_V40(m_lUserID, pathBytes.data(), &downloadCond);
    if (m_lFileHandle < 0) {
        NET_DVR_TIME startTimeOld;
        std::memset(&startTimeOld, 0, sizeof(NET_DVR_TIME));
        startTimeOld.dwYear = seg.startTime.date().year();
        startTimeOld.dwMonth = seg.startTime.date().month();
        startTimeOld.dwDay = seg.startTime.date().day();
        startTimeOld.dwHour = seg.startTime.time().hour();
        startTimeOld.dwMinute = seg.startTime.time().minute();
        startTimeOld.dwSecond = seg.startTime.time().second();
        
        NET_DVR_TIME stopTimeOld;
        std::memset(&stopTimeOld, 0, sizeof(NET_DVR_TIME));
        stopTimeOld.dwYear = seg.endTime.date().year();
        stopTimeOld.dwMonth = seg.endTime.date().month();
        stopTimeOld.dwDay = seg.endTime.date().day();
        stopTimeOld.dwHour = seg.endTime.time().hour();
        stopTimeOld.dwMinute = seg.endTime.time().minute();
        stopTimeOld.dwSecond = seg.endTime.time().second();
        
        m_lFileHandle = NET_DVR_GetFileByTime(m_lUserID, m_realSdkChannel, &startTimeOld, &stopTimeOld, pathBytes.data());
    }

    if (m_lFileHandle < 0) {
        int err = NET_DVR_GetLastError();
        NET_DVR_Logout(m_lUserID);
        m_lUserID = -1;
        m_isDownloading = false;
        emit isDownloadingChanged();
        emit downloadFinished(false, tr("LNG_00497").arg(m_currentSegmentIndex + 1).arg(err));
        return;
    }

    if (!NET_DVR_PlayBackControl_V40(m_lFileHandle, NET_DVR_PLAYSTART, nullptr, 0, nullptr, nullptr)) {
        NET_DVR_StopGetFile(m_lFileHandle);
        NET_DVR_Logout(m_lUserID);
        m_lFileHandle = -1;
        m_lUserID = -1;
        m_isDownloading = false;
        emit isDownloadingChanged();
        emit downloadFinished(false, tr("LNG_00496").arg(m_currentSegmentIndex + 1).arg(NET_DVR_GetLastError()));
        return;
    }

    m_progress = 0;
    m_lastFileSize = 0;
    m_stalledTicks = 0;
    m_ffmpegFallbackAttempted = false;
    emit progressChanged();
    emit overallProgressChanged();

    m_statusText = tr("LNG_00495").arg(m_currentSegmentIndex + 1).arg(m_totalSegmentsCount);
    emit statusTextChanged();

    m_timer->start();
}

void HikvisionDownloader::stopDownload()
{
    if (!m_isDownloading) return;

    m_stopping = true;
    m_timer->stop();
    m_segments.clear();

    // Interrupt search thread if running
    {
        std::lock_guard<std::mutex> lock(m_searchMutex);
        if (m_searchThread) {
            m_searchThread->requestInterruption();
        }
    }

    if (m_ffmpegProcess->state() != QProcess::NotRunning) {
        m_ffmpegProcess->kill();
        m_ffmpegProcess->waitForFinished(1000);
        QFile::remove(m_tempFilePath);
        QFile::remove(m_finalFilePath);
    }

    if (m_lFileHandle >= 0) {
        NET_DVR_StopGetFile(m_lFileHandle);
        m_lFileHandle = -1;
    }

    // Clean up temporary download file if exists
    if (!m_tempFilePath.isEmpty()) {
        QFile::remove(m_tempFilePath);
    }

    if (m_lUserID >= 0) {
        NET_DVR_Logout(m_lUserID);
        m_lUserID = -1;
    }

    m_stopping = false;
    m_isDownloading = false;
    m_isConverting = false;
    emit isConvertingChanged();
    m_progress = 0;
    m_statusText = tr("LNG_00025");
    emit isDownloadingChanged();
    emit progressChanged();
    emit overallProgressChanged();
    emit statusTextChanged();
    emit downloadFinished(false, tr("LNG_00494"));
}

void HikvisionDownloader::checkProgress()
{
    if (m_lFileHandle < 0) return;

    qint64 currentSize = getActualFileSize(m_tempFilePath);
    qint64 diff = currentSize - m_lastFileSize;
    if (diff > 0) {
        g_networkBytesAccumulator.fetch_add(diff, std::memory_order_relaxed);
        m_lastFileSize = currentSize;
        m_stalledTicks = 0;
    } else if (currentSize > 0) {
        m_stalledTicks++;
    }

    int pos = NET_DVR_GetDownloadPos(m_lFileHandle);
    bool stalledButComplete = (currentSize > 4096) &&
                              ((pos >= 90 && m_stalledTicks >= 3) || (m_stalledTicks >= 5));

    if (pos == 100 || pos == 200 || pos < 0 || stalledButComplete) {
        m_timer->stop();
        NET_DVR_StopGetFile(m_lFileHandle);
        m_lFileHandle = -1;

        // Allow HCNetSDK worker thread to flush and close the file handle on Windows
        QThread::msleep(50);

        qint64 finalSize = getActualFileSize(m_tempFilePath);
        qint64 finalDiff = finalSize - m_lastFileSize;
        if (finalDiff > 0) {
            g_networkBytesAccumulator.fetch_add(finalDiff, std::memory_order_relaxed);
            m_lastFileSize = finalSize;
        }

        bool isSuccess = (finalSize > 0) && (pos == 100 || stalledButComplete || finalSize > 4096);

        if (isSuccess) {
            m_progress = 100;
            emit progressChanged();
            emit overallProgressChanged();

            startConversion();
        } else {
            if (m_lUserID >= 0) {
                NET_DVR_Logout(m_lUserID);
                m_lUserID = -1;
            }
            if (!m_tempFilePath.isEmpty()) {
                QFile::remove(m_tempFilePath);
            }
            m_isDownloading = false;
            m_isConverting = false;
            emit isConvertingChanged();
            m_progress = 0;
            emit isDownloadingChanged();
            emit progressChanged();
            emit overallProgressChanged();
            emit downloadFinished(false, tr("LNG_00492").arg(m_currentSegmentIndex + 1));
        }
    } else {
        if (m_progress != pos) {
            m_progress = pos;
            emit progressChanged();
            emit overallProgressChanged();
        }
    }
}

void HikvisionDownloader::startConversion()
{
    if (!m_finalFilePath.endsWith(QStringLiteral(".mp4"), Qt::CaseInsensitive)) {
        finishSegmentConversionSuccess(false);
        return;
    }

    m_isConverting = true;
    m_ffmpegFallbackAttempted = false;
    emit isConvertingChanged();
    m_statusText = tr("LNG_00493").arg(m_currentSegmentIndex + 1).arg(m_totalSegmentsCount);
    emit statusTextChanged();

    const QString ffmpegBin = resolveFfmpegExecutable();
    QStringList args;
    args << QStringLiteral("-y")
         << QStringLiteral("-fflags") << QStringLiteral("+genpts")
         << QStringLiteral("-i") << QDir::toNativeSeparators(m_tempFilePath)
         << QStringLiteral("-c:v") << QStringLiteral("copy")
         << QStringLiteral("-c:a") << QStringLiteral("aac")
         << QDir::toNativeSeparators(m_finalFilePath);
    m_ffmpegProcess->start(ffmpegBin, args);
}

void HikvisionDownloader::finishSegmentConversionSuccess(bool removeTempFile)
{
    m_isConverting = false;
    emit isConvertingChanged();

    if (removeTempFile && !m_tempFilePath.isEmpty()) {
        QFile::remove(m_tempFilePath);
    }
    m_convertedSegmentsCount++;
    m_currentSegmentIndex++;
    m_statusText = tr("LNG_00491").arg(m_convertedSegmentsCount).arg(m_totalSegmentsCount);
    emit statusTextChanged();

    startNextSegment();
}

void HikvisionDownloader::handleConversionFailure(const QString &reason)
{
    m_isConverting = false;
    emit isConvertingChanged();
    m_isDownloading = false;
    emit isDownloadingChanged();
    if (m_lUserID >= 0) {
        NET_DVR_Logout(m_lUserID);
        m_lUserID = -1;
    }
    emit downloadFinished(false, tr("LNG_00489").arg(m_currentSegmentIndex + 1).arg(reason.left(100)));
}

void HikvisionDownloader::onFfmpegError(QProcess::ProcessError error)
{
    if (m_stopping || !m_isConverting) {
        return;
    }
    if (error == QProcess::FailedToStart) {
        if (remuxPsToMp4InProcess(m_tempFilePath, m_finalFilePath)) {
            finishSegmentConversionSuccess(true);
        } else {
            handleConversionFailure(tr("LNG_00490"));
        }
    }
}

void HikvisionDownloader::onFfmpegFinished(int exitCode, QProcess::ExitStatus exitStatus)
{
    if (m_stopping || !m_isConverting) {
        return;
    }

    if (exitStatus == QProcess::NormalExit && exitCode == 0 && getActualFileSize(m_finalFilePath) > 0) {
        finishSegmentConversionSuccess(true);
        return;
    }

    // Retry once without audio (-c:v copy -an) if the audio track in the PS container failed to decode
    if (!m_ffmpegFallbackAttempted) {
        m_ffmpegFallbackAttempted = true;
        const QString ffmpegBin = resolveFfmpegExecutable();
        QStringList args;
        args << QStringLiteral("-y")
             << QStringLiteral("-fflags") << QStringLiteral("+genpts")
             << QStringLiteral("-i") << QDir::toNativeSeparators(m_tempFilePath)
             << QStringLiteral("-c:v") << QStringLiteral("copy")
             << QStringLiteral("-an")
             << QDir::toNativeSeparators(m_finalFilePath);
        m_ffmpegProcess->start(ffmpegBin, args);
        return;
    }

    // Fall back to in-process libavformat remuxing
    if (remuxPsToMp4InProcess(m_tempFilePath, m_finalFilePath)) {
        finishSegmentConversionSuccess(true);
        return;
    }

    QByteArray stderrOutput = m_ffmpegProcess->readAllStandardError();
    QString shortError = QString::fromUtf8(stderrOutput.trimmed());
    if (shortError.isEmpty()) {
        shortError = tr("LNG_00490");
    } else {
        QStringList lines = shortError.split('\n');
        if (!lines.isEmpty()) {
            shortError = lines.last().trimmed();
            if (shortError.isEmpty() && lines.size() > 1) {
                shortError = lines[lines.size() - 2].trimmed();
            }
        }
    }
    handleConversionFailure(shortError);
}
