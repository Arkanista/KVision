# KVision Codebase Map & API Reference

This document serves as an **index and API cheat-sheet** for AI agents.

---

## 1. Quick QML Types & Singletons Reference

| QML Type Name | Module | C++ Class | Type | File |
| :--- | :--- | :--- | :--- | :--- |
| `Context` | `CCTV_Viewer.Core` | [`Context`](file:///home/robert/cctv/kvision/src/context.h) | Singleton | [`src/context.cpp`](file:///home/robert/cctv/kvision/src/context.cpp) |
| `SystemStats` | `CCTV_Viewer.Core` | [`SystemStats`](file:///home/robert/cctv/kvision/src/systemstats.h) | Singleton | [`src/systemstats.cpp`](file:///home/robert/cctv/kvision/src/systemstats.cpp) |
| `Clipboard` | `CCTV_Viewer.Utils` | [`Clipboard`](file:///home/robert/cctv/kvision/src/clipboard.h) | Singleton | [`src/clipboard.h`](file:///home/robert/cctv/kvision/src/clipboard.h) |
| `EventFilter` | `CCTV_Viewer.Utils` | [`EventFilter`](file:///home/robert/cctv/kvision/src/eventfilter.h) | Instantiable | [`src/eventfilter.cpp`](file:///home/robert/cctv/kvision/src/eventfilter.cpp) |
| `HikvisionManager` | `CCTV_Viewer.Hikvision` | [`HikvisionManager`](file:///home/robert/cctv/kvision/src/hikvisionmanager.h) | Singleton | [`src/hikvisionmanager.cpp`](file:///home/robert/cctv/kvision/src/hikvisionmanager.cpp) |
| `HikvisionISAPI` | `CCTV_Viewer.Hikvision` | [`HikvisionISAPI`](file:///home/robert/cctv/kvision/src/hikvisionisapi.h) | Singleton | [`src/hikvisionisapi.cpp`](file:///home/robert/cctv/kvision/src/hikvisionisapi.cpp) |
| `HikvisionPlayer` | `CCTV_Viewer.Hikvision` | [`HikvisionPlayer`](file:///home/robert/cctv/kvision/src/hikvisionplayer.h) | Item | [`src/hikvisionplayer.cpp`](file:///home/robert/cctv/kvision/src/hikvisionplayer.cpp) |
| `HikvisionArchivePlayer` | `CCTV_Viewer.Hikvision` | [`HikvisionArchivePlayer`](file:///home/robert/cctv/kvision/src/hikvisionarchiveplayer.h) | Item | [`src/hikvisionarchiveplayer.cpp`](file:///home/robert/cctv/kvision/src/hikvisionarchiveplayer.cpp) |
| `HikvisionDownloader` | `CCTV_Viewer.Hikvision` | [`HikvisionDownloader`](file:///home/robert/cctv/kvision/src/hikvisiondownloader.h) | Instantiable | [`src/hikvisiondownloader.cpp`](file:///home/robert/cctv/kvision/src/hikvisiondownloader.cpp) |
| `QmlAVPlayer` | `CCTV_Viewer.Multimedia` | [`QmlAVPlayer`](file:///home/robert/cctv/kvision/src/qmlav/src/qmlavplayer.h) | Item | [`src/qmlav/src/qmlavplayer.cpp`](file:///home/robert/cctv/kvision/src/qmlav/src/qmlavplayer.cpp) |
| `ViewportsLayoutItem` | `CCTV_Viewer.Models` | [`ViewportsLayoutItem`](file:///home/robert/cctv/kvision/src/viewportslayoutmodel.h#L13) | Instantiable | [`src/viewportslayoutmodel.cpp`](file:///home/robert/cctv/kvision/src/viewportslayoutmodel.cpp) |
| `ViewportsLayoutModel` | `CCTV_Viewer.Models` | [`ViewportsLayoutModel`](file:///home/robert/cctv/kvision/src/viewportslayoutmodel.h#L43) | ListModel | [`src/viewportslayoutmodel.cpp`](file:///home/robert/cctv/kvision/src/viewportslayoutmodel.cpp) |
| `ViewportsLayoutsCollectionModel` | `CCTV_Viewer.Models` | [`ViewportsLayoutsCollectionModel`](file:///home/robert/cctv/kvision/src/viewportslayoutscollectionmodel.h) | ListModel | [`src/viewportslayoutscollectionmodel.cpp`](file:///home/robert/cctv/kvision/src/viewportslayoutscollectionmodel.cpp) |
| `NvrStatusManager` | Context Property | [`NvrStatusManager`](file:///home/robert/cctv/kvision/src/nvrstatusmanager.h) | Singleton | [`src/nvrstatusmanager.cpp`](file:///home/robert/cctv/kvision/src/nvrstatusmanager.cpp) |
| `image://cctv/...` | Image Provider | [`ThumbnailProvider`](file:///home/robert/cctv/kvision/src/thumbnailprovider.h) | Provider | [`src/thumbnailprovider.cpp`](file:///home/robert/cctv/kvision/src/thumbnailprovider.cpp) |

---

## 2. Detailed C++ Class Index

### [`Context`](file:///home/robert/cctv/kvision/src/context.h) (`CCTV_Viewer.Core`)
* **Properties**: `config` (`Config*`), `isAuxiliary` (bool), `auxiliaryId` (int), `isFirstRun` (bool), `mockNewVersion` (bool).
* **Methods (`Q_INVOKABLE`)**:
  * `setLanguage(QString)` / `getLanguage()` – Runtime i18n locale switcher.
  * `startAuxiliaryProcess()` – Spawns a secondary window on another monitor (`kvision --auxiliary <id>`).
  * `trimMemory()` – Calls `malloc_trim(0)` to purge glibc unused heap pages.
  * `mkpath(dirPath)` / `dirExists(dirPath)` / `homePath()` / `pathToUrl(path)` – Filesystem helpers.
  * `readSetting(category, key, defaultVal)` / `writeSetting(category, key, val)` – Direct INI access.
  * `readLocalFile(filePath)` – Reads text/markdown content for in-app help.
* **Signals**: `languageChanged()`, `configFileChanged()`.

### [`HikvisionManager`](file:///home/robert/cctv/kvision/src/hikvisionmanager.h) (`CCTV_Viewer.Hikvision`)
* **Methods (`Q_INVOKABLE` / Public)**:
  * `discoverCameras(ip, port, httpPort, user, pass)` (sync) / `discoverCamerasAsync(...)` (async `QThread`).
  * `logout(ip)` / `isLogged(ip)` – SDK session tracking.
  * `loginShared(ip, port, user, pass, deviceInfo)` / `logoutShared(ip)` – Shared session pool for playback players.
  * `ptzZoom(ip, port, user, pass, channelId, command, stop)` – Enqueues PTZ zoom in background worker.
  * `forceIFrame(ip, port, user, pass, channelId)` – Requests immediate keyframe for fast channel switching.
* **Signals**: `sessionStatusChanged(ip, loggedIn)`, `discoveryFinished(ip, cameras, success, errorMsg)`.

### [`HikvisionArchivePlayer`](file:///home/robert/cctv/kvision/src/hikvisionarchiveplayer.h) (`CCTV_Viewer.Hikvision`)
* **Properties**: `recorderIp`, `channelId`, `port`, `username`, `password`, `currentPlayheadMs`, `isPlaying`, `videoWidth`, `videoHeight`, `fps`, `volume`, `muted`, `playerStatusMessage`.
* **Methods (`Q_INVOKABLE`)**:
  * `playAtTime(QDateTime)` – Starts archive playback from specific timestamp via `NET_DVR_PlayBackByTime_V40`.
  * `setPlaybackSpeed(int)` – Multiplier: `1, 2, 4, 8` (fast-forward) or `-1, -2, -4, -8` (reverse).
  * `pause()` / `resume()` / `stop()`.
  * `hasActiveStream()` / `hasReceivedFrames()`.
  * `saveCurrentFrame(filePath)` – Dumps RGB buffer snapshot to disk.
* **Internal**: `DecCallBack` + `FrameBufferPool` (zero-copy YV12 $\to$ RGB conversion) and `AudioCallBack` $\to$ `QAudioOutput`.

### [`HikvisionISAPI`](file:///home/robert/cctv/kvision/src/hikvisionisapi.h) (`CCTV_Viewer.Hikvision`)
* **Methods (`Q_INVOKABLE`)**:
  * `searchRecordings(recorderInfo, channelId, start, end)` – Queries `/ISAPI/ContentMgmt/search` with Digest Auth.
  * `searchMonthAvailability(recorderInfo, channelId, year, month)` – Fetches days containing recordings for calendar.
  * `cancelAllSearches()` – Aborts in-flight `QNetworkReply` requests.
* **Signals**: `searchFinished(...)`, `searchFailed(...)`, `monthAvailabilityFinished(...)`.

### [`HikvisionDownloader`](file:///home/robert/cctv/kvision/src/hikvisiondownloader.h) (`CCTV_Viewer.Hikvision`)
* **Properties**: `isDownloading`, `isConverting`, `progress` (0-100), `overallProgress` (0-100), `statusText`.
* **Methods (`Q_INVOKABLE`)**:
  * `startDownload(recorderInfo, channelId, start, end, saveFilePath)` – Downloads chunk via SDK and remuxes to MP4 using `ffmpeg`.
  * `stopDownload()` – Aborts download and terminates child `ffmpeg` process.
* **Signals**: `downloadFinished(bool success, QString message)`.

### [`NvrStatusManager`](file:///home/robert/cctv/kvision/src/nvrstatusmanager.h) (Context Property)
* **Properties**: `hasErrors`, `errors` (QVariantList), `isChecking`, `checkedRecorders`, `monitoringEnabled`, `checkOffline`, `checkCpu`, `checkHw`, `checkHdd`, `checkUnformatted`, `checkFull`.
* **Methods (`Q_INVOKABLE`)**:
  * `checkNow()` – Triggers immediate background check (`NvrStatusWorker` in `QThread`).
  * `onRecordersChanged()` – Reloads NVR list from settings.
  * `isRecorderMuted(name)` / `setRecorderMuted(name, muted)` – Muting configuration.
* **Signals**: `hasErrorsChanged()`, `errorsChanged()`, `checkedRecordersChanged()`.

### [`QmlAVPlayer`](file:///home/robert/cctv/kvision/src/qmlav/src/qmlavplayer.h) (`CCTV_Viewer.Multimedia`)
* **Properties**: `source` (QUrl/RTSP), `videoSurface`, `playbackState`, `status`, `muted`, `volume`, `fps`, `hasVideo`, `hasAudio`, `avOptions`.
* **Slots / Invokables**: `play()`, `stop()`, `bytesRead()`.
* **Internal**: Custom demuxer (`qmlavdemuxer.cpp`) & decoder (`qmlavdecoder.cpp`) supporting HW acceleration.

### [`SystemStats`](file:///home/robert/cctv/kvision/src/systemstats.h) (`CCTV_Viewer.Core`)
* **Properties**: `active` (bool), `cpuUsage`, `gpuUsage`, `ramUsage`, `vramUsage`, `netUsage` (double %).
* **Internal**: Threaded collector (`StatsWorker`) polling Linux `/proc/stat`, `/proc/<pid>/stat`, and NVML/DRM timers.

---

## 3. QML Component Architecture

```
+-------------------------------------------------------------------------------+
|                                 RootWindow.qml                                |
|  - Top header toolbar (Layout switcher, Fullscreen, Mute, Add camera, Playback)|
|  - SideBar.qml (Recorders/Channels collapsible tree & status badges)          |
|  - Central Area: ViewportsLayout.qml                                          |
+-------------------------------------------------------------------------------+
                                         |
                                         v
                         +-------------------------------+
                         |      ViewportsLayout.qml      |
                         |  - Manages grid layout & drag |
                         |  - 1x1, 2x2, 3x3, 4x4 matrix  |
                         +-------------------------------+
                                         |
                                         v (Creates N tiles)
                         +-------------------------------+
                         |          Player.qml           |
                         |  - OSD Overlay (Name, FPS)    |
                         |  - PTZ Zoom gesture handling  |
                         |  - Video: QmlAV / HikPlayer   |
                         +-------------------------------+
```

### Key QML File Roles
* [`src/RootWindow.qml`](file:///home/robert/cctv/kvision/src/RootWindow.qml): Orchestrates window geometry, keyboard shortcuts, full-screen transitions, and handles `Context.onConfigFileChanged`.
* [`src/PlaybackWindow.qml`](file:///home/robert/cctv/kvision/src/PlaybackWindow.qml): Archive video player with interactive 24-hour timeline bar, calendar picker, multi-speed playback, audio control, and frame-stepping.
* [`src/DownloadDialog.qml`](file:///home/robert/cctv/kvision/src/DownloadDialog.qml): Modal for selecting time intervals and exporting camera footage to `.mp4` via `HikvisionDownloader`.
* [`src/NvrCamerasWindow.qml`](file:///home/robert/cctv/kvision/src/NvrCamerasWindow.qml) & [`src/NvrSettingsPanel.qml`](file:///home/robert/cctv/kvision/src/NvrSettingsPanel.qml): NVR management, channel auto-discovery, IP/port/credentials configuration.
* [`src/NvrStatusDialog.qml`](file:///home/robert/cctv/kvision/src/NvrStatusDialog.qml): Health diagnostic popup displaying HDD errors, CPU overload, and offline cameras.
* [`src/AuxiliaryWindow.qml`](file:///home/robert/cctv/kvision/src/AuxiliaryWindow.qml): Detached secondary window for multi-monitor setups.
