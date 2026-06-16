# CCTV-Viewer2: Antigravity Session Transfer Package

> [!IMPORTANT]
> **To the next Antigravity AI instance:**
> This file contains the complete context, analysis, and code implementation details for two issues resolved/analyzed during the previous pair-programming session. Read this file carefully to understand the context and immediately execute the changes.

---

## 1. Context & Goals

We analyzed and prepared implementation plans for two problems in the `cctv-viewer2` Qt/QML project:
1. **Problem 1 (Sequential Archive Download & Conversion)**: Large video downloads are split into ~1GB parts by the Hikvision SDK (e.g., `file.ps`, `file_1.ps`, `file_2.ps`). The current code only converts the first part `file.ps` to `file.mp4`, leaving other parts unconverted. We want the program to download each 1GB part sequentially, convert it to MP4 immediately after it finishes downloading, delete the `.ps` file, and then proceed to the next part. We also want to display a progress status (e.g., "Pobrano i przekonwertowano 3 z 3 plików") in the download dialog.
2. **Problem 2 (Thread & Memory Leaks in Viewports)**: Switching between camera layouts (views) in the live view causes memory and CPU/network usage to grow, and returning to a single view does not free it. This happens because QML `StackLayout` hides inactive layout views, but the child `Player.qml` elements keep their local `visible` property as `true`, so `onVisibleChanged` is never called, leaving RTSP and mock threads running in the background.

---

## 2. Technical Analysis & Solution Details

### Problem 1: Sequential 1GB Downloads & Conversions
* **Mechanism**: Use `NET_DVR_FindFile_V40` and `NET_DVR_FindNextFile_V50` to query the list of physical files (segments) recorded on the NVR for the requested time range.
* **Algorithm**:
  1. Find all files, intersect their times with the user's requested `start`/`end` times, and sort them chronologically.
  2. Save them as a list of segments in `HikvisionDownloader`.
  3. Download the first segment.
  4. Upon success, keep the NVR logged in, set status to `"Konwertowanie części X z Y..."`, and run FFmpeg.
  5. In `onFfmpegFinished`, delete the `.ps` part, increment the index, and call `startNextSegment()`.
  6. When all parts are done, logout and emit `downloadFinished(true, "Pobrano i przekonwertowano Y z Y plików.")`.
  7. In `DownloadDialog.qml`, bind to `statusText` to display `"Pobieranie części X z Y... XX%"` and the final success message.

### Problem 2: Thread & Memory Leaks (Inactive layouts)
* **Root cause**: In QML, parent `visible: false` does not change the local `visible` property of child items. Thus `Player.qml` `onVisibleChanged` was never triggered, leaking RTSP/mock player threads in hidden layouts.
* **Solution**: 
  1. In `ViewportsLayout.qml`, bind `Player.visible` to the root layout's visibility (`visible: root.visible`).
  2. In `Player.qml`, bind `HikvisionPlayer.visible` to include its parent `Player`'s visibility (`visible: root.isHikvision && !hikPlayerSettings.useRealStreams && root.visible`).

---

## 3. Actionable Code Specifications

Below are the exact code modifications to apply to the codebase.

### File: `src/hikvisiondownloader.h`
```diff
--- src/hikvisiondownloader.h
+++ src/hikvisiondownloader.h
@@ -5,2 +5,4 @@
 #include <QVariantMap>
 #include <QDateTime>
 #include <QTimer>
 #include <QProcess>
+#include <QList>
+#include <QPair>
 #include "hcnetsdk_compat.h"
 
 class HikvisionDownloader : public QObject
 {
     Q_OBJECT
     Q_PROPERTY(bool isDownloading READ isDownloading NOTIFY isDownloadingChanged)
     Q_PROPERTY(int progress READ progress NOTIFY progressChanged)
+    Q_PROPERTY(QString statusText READ statusText NOTIFY statusTextChanged)
 
 public:
     explicit HikvisionDownloader(QObject *parent = nullptr);
     ~HikvisionDownloader() override;
 
     bool isDownloading() const;
     int progress() const;
+    QString statusText() const;
 
     Q_INVOKABLE void startDownload(const QVariantMap &recorderInfo, int channelId, const QDateTime &start, const QDateTime &end, const QString &saveFilePath);
     Q_INVOKABLE void stopDownload();
 
 signals:
     void isDownloadingChanged();
     void progressChanged();
+    void statusTextChanged();
     void downloadFinished(bool success, const QString &message);
 
 private slots:
     void checkProgress();
     void onFfmpegFinished(int exitCode, QProcess::ExitStatus exitStatus);
 
 private:
+    void startNextSegment();
+
     bool m_isDownloading;
     int m_progress;
+    QString m_statusText;
     LONG m_lUserID;
     LONG m_lFileHandle;
     QTimer *m_timer;
     QString m_tempFilePath;
     QString m_finalFilePath;
     QProcess *m_ffmpegProcess;
     qint64 m_lastFileSize = 0;
+
+    struct DownloadSegment {
+        QDateTime startTime;
+        QDateTime endTime;
+        QString tempPath;
+        QString finalPath;
+    };
+
+    QList<DownloadSegment> m_segments;
+    int m_currentSegmentIndex = 0;
+    int m_totalSegmentsCount = 0;
+    int m_convertedSegmentsCount = 0;
+
+    QVariantMap m_recorderInfo;
+    int m_channelId;
+    int m_realSdkChannel;
 };
```

### File: `src/hikvisiondownloader.cpp`
```diff
--- src/hikvisiondownloader.cpp
+++ src/hikvisiondownloader.cpp
@@ -4,2 +4,3 @@
 #include <QDebug>
 #include <QThread>
 #include <QDir>
 #include <QFileInfo>
+#include <algorithm>
 
 HikvisionDownloader::HikvisionDownloader(QObject *parent)
     : QObject(parent)
     , m_isDownloading(false)
     , m_progress(0)
+    , m_statusText("")
     , m_lUserID(-1)
     , m_lFileHandle(-1)
 {
@@ -28,2 +29,7 @@
 bool HikvisionDownloader::isDownloading() const
 {
     return m_isDownloading;
 }
 
+QString HikvisionDownloader::statusText() const
+{
+    return m_statusText;
+}
+
 int HikvisionDownloader::progress() const
 {
     return m_progress;
 }
 
 void HikvisionDownloader::startDownload(const QVariantMap &recorderInfo, int channelId, const QDateTime &start, const QDateTime &end, const QString &saveFilePath)
 {
     if (m_isDownloading) {
         emit downloadFinished(false, "Pobieranie już trwa.");
         return;
     }
 
+    m_recorderInfo = recorderInfo;
+    m_channelId = channelId;
+
     QString ip = recorderInfo["ip"].toString();
     int port = recorderInfo["port"].toInt();
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
 
     m_lUserID = NET_DVR_Login_V40(&loginInfo, &deviceInfo);
     if (m_lUserID < 0) {
         emit downloadFinished(false, QString("Błąd logowania do urządzenia: %1").arg(NET_DVR_GetLastError()));
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
+    m_realSdkChannel = realSdkChannel;
 
-    NET_DVR_PLAYCOND downloadCond;
-    std::memset(&downloadCond, 0, sizeof(NET_DVR_PLAYCOND));
-    downloadCond.dwChannel = static_cast<DWORD>(realSdkChannel);
-
-    downloadCond.struStartTime.dwYear = start.date().year();
-    downloadCond.struStartTime.dwMonth = start.date().month();
-    downloadCond.struStartTime.dwDay = start.date().day();
-    downloadCond.struStartTime.dwHour = start.time().hour();
-    downloadCond.struStartTime.dwMinute = start.time().minute();
-    downloadCond.struStartTime.dwSecond = start.time().second();
-
-    downloadCond.struStopTime.dwYear = end.date().year();
-    downloadCond.struStopTime.dwMonth = end.date().month();
-    downloadCond.struStopTime.dwDay = end.date().day();
-    downloadCond.struStopTime.dwHour = end.time().hour();
-    downloadCond.struStopTime.dwMinute = end.time().minute();
-    downloadCond.struStopTime.dwSecond = end.time().second();
-
-    // Check if any files exist in this time range first
     NET_DVR_FILECOND_V40 findCond;
     std::memset(&findCond, 0, sizeof(NET_DVR_FILECOND_V40));
     findCond.lChannel = static_cast<LONG>(realSdkChannel);
     findCond.dwFileType = 0xFF; // All types
     findCond.dwIsLocked = 0xFF; // All locks
     findCond.dwUseCardNo = 0;
-    findCond.struStartTime = downloadCond.struStartTime;
-    findCond.struStopTime = downloadCond.struStopTime;
-
+    
+    findCond.struStartTime.dwYear = start.date().year();
+    findCond.struStartTime.dwMonth = start.date().month();
+    findCond.struStartTime.dwDay = start.date().day();
+    findCond.struStartTime.dwHour = start.time().hour();
+    findCond.struStartTime.dwMinute = start.time().minute();
+    findCond.struStartTime.dwSecond = start.time().second();
+
+    findCond.struStopTime.dwYear = end.date().year();
+    findCond.struStopTime.dwMonth = end.date().month();
+    findCond.struStopTime.dwDay = end.date().day();
+    findCond.struStopTime.dwHour = end.time().hour();
+    findCond.struStopTime.dwMinute = end.time().minute();
+    findCond.struStopTime.dwSecond = end.time().second();
+
+    m_segments.clear();
     LONG lFindHandle = NET_DVR_FindFile_V40(m_lUserID, &findCond);
     if (lFindHandle >= 0) {
         NET_DVR_FINDDATA_V50 findData;
-        int state = NET_DVR_FindNextFile_V50(lFindHandle, &findData);
-        NET_DVR_FindClose_V30(lFindHandle);
-        if (state == NET_DVR_FILE_NOFIND || state == NET_DVR_NOMOREFILE) {
-            emit downloadFinished(false, "Brak nagrań w wybranym przedziale czasowym dla tej kamery.");
-            NET_DVR_Logout(m_lUserID);
-            m_lUserID = -1;
-            return;
-        }
-    }
-
-    downloadCond.byStreamType = 0; // Main stream
-    downloadCond.byCourseFile = 0;
-    downloadCond.byDownload = 0; // 0 is default network download, 1 might trigger NVR local USB backup
-
-    m_finalFilePath = saveFilePath;
-    m_tempFilePath = saveFilePath;
-    if (m_finalFilePath.endsWith(".mp4", Qt::CaseInsensitive)) {
-        m_tempFilePath.replace(m_tempFilePath.length() - 4, 4, ".ps");
-    }
-
-    QFileInfo fileInfo(m_tempFilePath);
-    QDir().mkpath(fileInfo.absolutePath());
-
-    QByteArray pathBytes = m_tempFilePath.toLocal8Bit();
-    
-    qDebug() << "[HikArchive] Downloading logical channel" << channelId << "(SDK channel" << realSdkChannel << ") from" << start << "to" << end << "into" << m_tempFilePath;
-    
-    m_lFileHandle = NET_DVR_GetFileByTime_V40(m_lUserID, pathBytes.data(), &downloadCond);
-
-    if (m_lFileHandle < 0) {
-        qDebug() << "[HikArchive] NET_DVR_GetFileByTime_V40 failed:" << NET_DVR_GetLastError();
-        // Fallback to older API
-        NET_DVR_TIME startTimeOld;
-        std::memset(&startTimeOld, 0, sizeof(NET_DVR_TIME));
-        startTimeOld.dwYear = start.date().year();
-        startTimeOld.dwMonth = start.date().month();
-        startTimeOld.dwDay = start.date().day();
-        startTimeOld.dwHour = start.time().hour();
-        startTimeOld.dwMinute = start.time().minute();
-        startTimeOld.dwSecond = start.time().second();
-        
-        NET_DVR_TIME stopTimeOld;
-        std::memset(&stopTimeOld, 0, sizeof(NET_DVR_TIME));
-        stopTimeOld.dwYear = end.date().year();
-        stopTimeOld.dwMonth = end.date().month();
-        stopTimeOld.dwDay = end.date().day();
-        stopTimeOld.dwHour = end.time().hour();
-        stopTimeOld.dwMinute = end.time().minute();
-        stopTimeOld.dwSecond = end.time().second();
-        
-        m_lFileHandle = NET_DVR_GetFileByTime(m_lUserID, realSdkChannel, &startTimeOld, &stopTimeOld, pathBytes.data());
-    }
-
-    if (m_lFileHandle < 0) {
-        int err = NET_DVR_GetLastError();
-        qDebug() << "[HikArchive] NET_DVR_GetFileByTime failed:" << err;
-        NET_DVR_Logout(m_lUserID);
-        m_lUserID = -1;
-        emit downloadFinished(false, QString("Błąd inicjalizacji pobierania: %1").arg(err));
-        return;
-    }
-
-    if (!NET_DVR_PlayBackControl_V40(m_lFileHandle, NET_DVR_PLAYSTART, nullptr, 0, nullptr, nullptr)) {
-        NET_DVR_StopGetFile(m_lFileHandle);
-        NET_DVR_Logout(m_lUserID);
-        m_lFileHandle = -1;
-        m_lUserID = -1;
-        emit downloadFinished(false, QString("Błąd startu pobierania: %1").arg(NET_DVR_GetLastError()));
-        return;
-    }
-
-    m_isDownloading = true;
-    m_progress = 0;
-    m_lastFileSize = 0;
-    emit isDownloadingChanged();
-    emit progressChanged();
-
-    m_timer->start();
+        while (true) {
+            int state = NET_DVR_FindNextFile_V50(lFindHandle, &findData);
+            if (state == 1000) { // NET_DVR_FILE_SUCCESS
+                QDateTime fileStart(QDate(findData.struStartTime.wYear, findData.struStartTime.byMonth, findData.struStartTime.byDay),
+                                    QTime(findData.struStartTime.byHour, findData.struStartTime.byMinute, findData.struStartTime.bySecond));
+                QDateTime fileEnd(QDate(findData.struStopTime.wYear, findData.struStopTime.byMonth, findData.struStopTime.byDay),
+                                  QTime(findData.struStopTime.byHour, findData.struStopTime.byMinute, findData.struStopTime.bySecond));
+                
+                QDateTime intersectStart = fileStart > start ? fileStart : start;
+                QDateTime intersectEnd = fileEnd < end ? fileEnd : end;
+                
+                if (intersectStart < intersectEnd) {
+                    DownloadSegment seg;
+                    seg.startTime = intersectStart;
+                    seg.endTime = intersectEnd;
+                    m_segments.append(seg);
+                }
+            } else if (state == 1002) { // NET_DVR_ISFINDING
+                QThread::msleep(10);
+            } else {
+                break;
+            }
+        }
+        NET_DVR_FindClose_V30(lFindHandle);
+    }
+
+    if (m_segments.isEmpty()) {
+        emit downloadFinished(false, "Brak nagrań w wybranym przedziale czasowym dla tej kamery.");
+        NET_DVR_Logout(m_lUserID);
+        m_lUserID = -1;
+        return;
+    }
+
+    // Sort segments chronologically
+    std::sort(m_segments.begin(), m_segments.end(), [](const DownloadSegment &a, const DownloadSegment &b) {
+        return a.startTime < b.startTime;
+    });
+
+    // Generate filenames for segments
+    QString baseFinal = saveFilePath;
+    QString baseTemp = saveFilePath;
+    if (baseTemp.endsWith(".mp4", Qt::CaseInsensitive)) {
+        baseTemp.replace(baseTemp.length() - 4, 4, ".ps");
+    }
+
+    for (int i = 0; i < m_segments.size(); ++i) {
+        QString segFinal = baseFinal;
+        QString segTemp = baseTemp;
+        if (i > 0) {
+            if (segFinal.endsWith(".mp4", Qt::CaseInsensitive)) {
+                segFinal.insert(segFinal.length() - 4, QString("_%1").arg(i));
+            } else {
+                segFinal += QString("_%1").arg(i);
+            }
+            if (segTemp.endsWith(".ps", Qt::CaseInsensitive)) {
+                segTemp.insert(segTemp.length() - 3, QString("_%1").arg(i));
+            } else {
+                segTemp += QString("_%1").arg(i);
+            }
+        }
+        m_segments[i].finalPath = segFinal;
+        m_segments[i].tempPath = segTemp;
+    }
+
+    m_isDownloading = true;
+    m_currentSegmentIndex = 0;
+    m_totalSegmentsCount = m_segments.size();
+    m_convertedSegmentsCount = 0;
+    emit isDownloadingChanged();
+
+    startNextSegment();
 }
 
+void HikvisionDownloader::startNextSegment()
+{
+    if (m_currentSegmentIndex >= m_segments.size()) {
+        m_isDownloading = false;
+        emit isDownloadingChanged();
+        
+        NET_DVR_Logout(m_lUserID);
+        m_lUserID = -1;
+        
+        QString summaryMsg = QString("Pobrano i przekonwertowano %1 z %2 plików.").arg(m_convertedSegmentsCount).arg(m_totalSegmentsCount);
+        m_statusText = summaryMsg;
+        emit statusTextChanged();
+        emit downloadFinished(true, summaryMsg);
+        return;
+    }
+
+    const DownloadSegment &seg = m_segments.at(m_currentSegmentIndex);
+    m_tempFilePath = seg.tempPath;
+    m_finalFilePath = seg.finalPath;
+
+    NET_DVR_PLAYCOND downloadCond;
+    std::memset(&downloadCond, 0, sizeof(NET_DVR_PLAYCOND));
+    downloadCond.dwChannel = static_cast<DWORD>(m_realSdkChannel);
+    downloadCond.struStartTime.dwYear = seg.startTime.date().year();
+    downloadCond.struStartTime.dwMonth = seg.startTime.date().month();
+    downloadCond.struStartTime.dwDay = seg.startTime.date().day();
+    downloadCond.struStartTime.dwHour = seg.startTime.time().hour();
+    downloadCond.struStartTime.dwMinute = seg.startTime.time().minute();
+    downloadCond.struStartTime.dwSecond = seg.startTime.time().second();
+
+    downloadCond.struStopTime.dwYear = seg.endTime.date().year();
+    downloadCond.struStopTime.dwMonth = seg.endTime.date().month();
+    downloadCond.struStopTime.dwDay = seg.endTime.date().day();
+    downloadCond.struStopTime.dwHour = seg.endTime.time().hour();
+    downloadCond.struStopTime.dwMinute = seg.endTime.time().minute();
+    downloadCond.struStopTime.dwSecond = seg.endTime.time().second();
+
+    downloadCond.byStreamType = 0; // Main stream
+    downloadCond.byCourseFile = 0;
+    downloadCond.byDownload = 0;
+
+    QFileInfo fileInfo(m_tempFilePath);
+    QDir().mkpath(fileInfo.absolutePath());
+    QByteArray pathBytes = m_tempFilePath.toLocal8Bit();
+
+    m_lFileHandle = NET_DVR_GetFileByTime_V40(m_lUserID, pathBytes.data(), &downloadCond);
+    if (m_lFileHandle < 0) {
+        NET_DVR_TIME startTimeOld;
+        std::memset(&startTimeOld, 0, sizeof(NET_DVR_TIME));
+        startTimeOld.dwYear = seg.startTime.date().year();
+        startTimeOld.dwMonth = seg.startTime.date().month();
+        startTimeOld.dwDay = seg.startTime.date().day();
+        startTimeOld.dwHour = seg.startTime.time().hour();
+        startTimeOld.dwMinute = seg.startTime.time().minute();
+        startTimeOld.dwSecond = seg.startTime.time().second();
+        
+        NET_DVR_TIME stopTimeOld;
+        std::memset(&stopTimeOld, 0, sizeof(NET_DVR_TIME));
+        stopTimeOld.dwYear = seg.endTime.date().year();
+        stopTimeOld.dwMonth = seg.endTime.date().month();
+        stopTimeOld.dwDay = seg.endTime.date().day();
+        stopTimeOld.dwHour = seg.endTime.time().hour();
+        stopTimeOld.dwMinute = seg.endTime.time().minute();
+        stopTimeOld.dwSecond = seg.endTime.time().second();
+        
+        m_lFileHandle = NET_DVR_GetFileByTime(m_lUserID, m_realSdkChannel, &startTimeOld, &stopTimeOld, pathBytes.data());
+    }
+
+    if (m_lFileHandle < 0) {
+        int err = NET_DVR_GetLastError();
+        NET_DVR_Logout(m_lUserID);
+        m_lUserID = -1;
+        m_isDownloading = false;
+        emit isDownloadingChanged();
+        emit downloadFinished(false, QString("Błąd inicjalizacji pobierania części %1: %2").arg(m_currentSegmentIndex + 1).arg(err));
+        return;
+    }
+
+    if (!NET_DVR_PlayBackControl_V40(m_lFileHandle, NET_DVR_PLAYSTART, nullptr, 0, nullptr, nullptr)) {
+        NET_DVR_StopGetFile(m_lFileHandle);
+        NET_DVR_Logout(m_lUserID);
+        m_lFileHandle = -1;
+        m_lUserID = -1;
+        m_isDownloading = false;
+        emit isDownloadingChanged();
+        emit downloadFinished(false, QString("Błąd startu pobierania części %1: %2").arg(m_currentSegmentIndex + 1).arg(NET_DVR_GetLastError()));
+        return;
+    }
+
+    m_progress = 0;
+    m_lastFileSize = 0;
+    emit progressChanged();
+
+    m_statusText = QString("Pobieranie części %1 z %2...").arg(m_currentSegmentIndex + 1).arg(m_totalSegmentsCount);
+    emit statusTextChanged();
+
+    m_timer->start();
+}
+
 void HikvisionDownloader::stopDownload()
 {
     if (!m_isDownloading) return;
 
     m_timer->stop();
+    m_segments.clear();
 
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
 
     if (m_lUserID >= 0) {
         NET_DVR_Logout(m_lUserID);
         m_lUserID = -1;
     }
 
     m_isDownloading = false;
     m_progress = 0;
+    m_statusText = "Zatrzymano";
     emit isDownloadingChanged();
     emit progressChanged();
+    emit statusTextChanged();
     emit downloadFinished(false, "Pobieranie przerwane przez użytkownika.");
 }
 
@@ -189,9 +274,7 @@
     int pos = NET_DVR_GetDownloadPos(m_lFileHandle);
     
     if (pos == 100 || pos == 200 || pos < 0) {
         m_timer->stop();
         NET_DVR_StopGetFile(m_lFileHandle);
-        NET_DVR_Logout(m_lUserID);
         m_lFileHandle = -1;
-        m_lUserID = -1;
         
         QFileInfo finalFi(m_tempFilePath);
         if (finalFi.exists()) {
@@ -211,7 +294,10 @@
             emit progressChanged();
             
             if (m_finalFilePath.endsWith(".mp4", Qt::CaseInsensitive)) {
-                emit downloadFinished(true, pos == 100 ? "Konwertowanie na MP4..." : "Zakończono (z ostrzeżeniem). Konwertowanie na MP4...");
+                m_statusText = QString("Konwertowanie części %1 z %2...").arg(m_currentSegmentIndex + 1).arg(m_totalSegmentsCount);
+                emit statusTextChanged();
                 m_ffmpegProcess->start("ffmpeg", QStringList() << "-y" << "-i" << m_tempFilePath << "-c:v" << "copy" << "-c:a" << "aac" << m_finalFilePath);
             } else {
-                m_isDownloading = false;
-                emit isDownloadingChanged();
-                emit downloadFinished(true, pos == 100 ? "Pobieranie zakończone pomyślnie." : "Pobieranie zakończone (z ostrzeżeniem).");
+                m_convertedSegmentsCount++;
+                m_currentSegmentIndex++;
+                startNextSegment();
             }
         } else {
+            if (m_lUserID >= 0) {
+                NET_DVR_Logout(m_lUserID);
+                m_lUserID = -1;
+            }
             m_isDownloading = false;
             m_progress = 0;
             emit isDownloadingChanged();
             emit progressChanged();
-            emit downloadFinished(false, "Błąd w trakcie pobierania (np. błąd sieci lub brak pliku).");
+            emit downloadFinished(false, QString("Błąd w trakcie pobierania części %1.").arg(m_currentSegmentIndex + 1));
         }
     } else {
         if (m_progress != pos) {
@@ -236,13 +322,17 @@
 void HikvisionDownloader::onFfmpegFinished(int exitCode, QProcess::ExitStatus exitStatus)
 {
-    m_isDownloading = false;
-    emit isDownloadingChanged();
-
     if (exitStatus == QProcess::NormalExit && exitCode == 0) {
         QFile::remove(m_tempFilePath);
-        emit downloadFinished(true, "Pobieranie i konwersja na MP4 zakończone pomyślnie.");
+        m_convertedSegmentsCount++;
+        m_currentSegmentIndex++;
+        m_statusText = QString("Pobrano i przekonwertowano %1 z %2 części...").arg(m_convertedSegmentsCount).arg(m_totalSegmentsCount);
+        emit statusTextChanged();
+        
+        startNextSegment();
     } else {
+        m_isDownloading = false;
+        emit isDownloadingChanged();
+        if (m_lUserID >= 0) {
+            NET_DVR_Logout(m_lUserID);
+            m_lUserID = -1;
+        }
         QByteArray stderrOutput = m_ffmpegProcess->readAllStandardError();
         QByteArray stdoutOutput = m_ffmpegProcess->readAllStandardOutput();
         
         QString shortError = QString::fromUtf8(stderrOutput.trimmed());
         if (shortError.isEmpty()) {
             shortError = "Błąd wewnętrzny FFmpeg";
         } else {
             QStringList lines = shortError.split('\n');
             if (!lines.isEmpty()) {
                 shortError = lines.last().trimmed();
                 if (shortError.isEmpty() && lines.size() > 1) {
                     shortError = lines[lines.size() - 2].trimmed();
                 }
             }
         }
-        emit downloadFinished(false, QString("Pobieranie zakończone, ale konwersja na MP4 nie powiodła się: %1").arg(shortError.left(100)));
+        emit downloadFinished(false, QString("Konwersja części %1 na MP4 nie powiodła się: %2").arg(m_currentSegmentIndex + 1).arg(shortError.left(100)));
     }
 }
```

### File: `src/DownloadDialog.qml`
```diff
--- src/DownloadDialog.qml
+++ src/DownloadDialog.qml
@@ -415,22 +415,31 @@
                     HikvisionDownloader {
                         id: rowDownloader
+                        onStatusTextChanged: {
+                            if (rowDownloader.statusText !== "") {
+                                model.statusText = rowDownloader.statusText
+                            }
+                        }
                         onProgressChanged: {
                             model.progress = rowDownloader.progress
                             if (rowDownloader.isDownloading) {
-                                model.statusText = "Pobieranie... " + rowDownloader.progress + "%"
+                                if (rowDownloader.statusText !== "") {
+                                    if (rowDownloader.statusText.indexOf("Konwertowanie") !== -1) {
+                                        model.statusText = rowDownloader.statusText
+                                    } else {
+                                        model.statusText = rowDownloader.statusText + " " + rowDownloader.progress + "%"
+                                    }
+                                } else {
+                                    model.statusText = "Pobieranie... " + rowDownloader.progress + "%"
+                                }
                             }
                         }
                         onDownloadFinished: {
                             model.isDownloading = false
                             if (success) {
-                                model.statusText = "Ukończono pomyślnie"
+                                model.statusText = message
                             } else {
                                 model.statusText = "Błąd: " + message
                             }
                         }
                     }
```

### File: `src/ViewportsLayout.qml`
```diff
--- src/ViewportsLayout.qml
+++ src/ViewportsLayout.qml
@@ -484,2 +484,3 @@
                         Player {
                             id: player
+                            visible: root.visible
                             index: model.index
```

### File: `src/Player.qml`
```diff
--- src/Player.qml
+++ src/Player.qml
@@ -350,2 +350,3 @@
             HikvisionPlayer {
-                visible: root.isHikvision && !hikPlayerSettings.useRealStreams
+                visible: root.isHikvision && !hikPlayerSettings.useRealStreams && root.visible
```

---

## 4. How to Apply These Changes

1. Open a terminal in the project directory.
2. Use the code modifications provided above.
3. Apply changes to C++ files (`src/hikvisiondownloader.h`, `src/hikvisiondownloader.cpp`) and QML files (`src/DownloadDialog.qml`, `src/ViewportsLayout.qml`, `src/Player.qml`).
4. Rebuild the project using standard CMake/Qt workflow:
   ```bash
   mkdir -p build && cd build
   cmake ..
   make -j$(nproc)
   ```
5. Run tests and verify both sequential 1GB download conversion and thread cleanups when switching views.
