# KVision Data Flows & Execution Lifecycles

This document details the step-by-step lifecycles, state machines, and sequence protocols across the system.

---

## 1. Live Video Streaming & Auto-Reconnect Lifecycle

```
[ User assigns camera to Player tile ]
                   |
                   v
[ Player.qml: Selects primary player (qmlAvPlayer1) ]
                   |
                   v
[ QmlAVPlayer::setSource(rtspUrl) ]
                   |
                   v
[ QmlAVDemuxer::load() ] ---> Spawns QmlAVThread (m_loaderThread)
                                       |
                                       v
                     [ avformat_open_input(dict) ]
                                       |
                   +-------------------+-------------------+
                   | Success                               | Timeout / Failure (5000ms)
                   v                                       v
[ avformat_find_stream_info() ]             [ Emit mediaStatusChanged(InvalidMedia) ]
                   |                                       |
                   v                                       v
[ QmlAVDemuxer::initDecoders() ]             [ Player.qml triggers reconnect timer ]
                   |                                       |
                   v                                       v
[ QmlAVVideoDecoder::open() ]               [ Exponential backoff (1s, 2s, 5s) ]
                   |                                       |
                   v                                       v
[ QmlAVDemuxer::start() ]                   [ Retries loading stream ]
                   |
                   v
+-------------------------------------------------------------+
| Demuxer Loop: av_read_frame() -> Packet Queue (Limit 64)   |
| Video Decoder: avcodec_send_packet() -> AVFrame (Limit 8)   |
| Direct Blit: Frame -> VideoOutput (OpenGL Texture)          |
+-------------------------------------------------------------+
```

### Stream Switching & Smooth Transition:
* `Player.qml` contains two instances: `qmlAvPlayer1` and `qmlAvPlayer2`.
* When switching between Main Stream (high resolution) and Sub Stream (low resolution), the secondary player pre-loads and buffers the new stream behind the scenes.
* Once the first decoded frame is presented (`framePresentedChanged`), visibility toggles instantly without a black frame.

---

## 2. Archive Search & Playback Synchronization Flow

```
1. Search Phase:
[ PlaybackWindow.qml ] 
        |
        v
[ HikvisionISAPI::searchMonthAvailability() ] ---> Queries HTTP /ISAPI/ContentMgmt/search
        |                                           Marks active calendar dates with dots
        v
[ HikvisionISAPI::searchRecordings(start, end) ]
        |
        v
[ NVR returns XML CMSearchDescription response with recording spans ]
        |
        v
[ Segments parsed into QVariantList -> Timeline Bar renders colored blocks ]

2. Playback Phase:
[ User clicks point on Timeline Bar (QDateTime) ]
        |
        v
[ HikvisionArchivePlayer::playAtTime(targetTime) ]
        |
        +---> [ HikvisionManager::loginShared() ] (Reuses cached lUserID)
        |
        v
[ NET_DVR_PlayBackByTime_V40(lUserID, realSdkChannel, &startTime, &stopTime) ]
        |
        v Returns lPlayHandle
+-------+-----------------------------------------------------+
| SDK Internal Playback Pipeline:                             |
| 1. Stream Packets arrive in PlayDataCallBack()              |
| 2. Decoded YV12 frames arrive in DecCallBack()              |
| 3. FrameBufferPool provides pre-allocated buffer memory     |
| 4. YV12ToRGBTask converts YV12 -> RGB32 in worker thread    |
| 5. QMetaObject::invokeMethod() schedules paint on GUI thread|
| 6. Audio samples in AudioCallBack() forwarded to QAudioOutput|
+-------------------------------------------------------------+
```

---

## 3. Video Clip Export & Download Flow

```
[ User selects Time Interval in DownloadDialog.qml ]
                         |
                         v
[ HikvisionDownloader::startDownload(recorderInfo, ch, start, end, targetFile) ]
                         |
                         v
[ Calculates realSdkChannel using byStartDChan formula ]
                         |
                         v
[ Queries recording segments in range via NET_DVR_FindFile_V40 ]
                         |
                         v (Iterates matching segments)
[ NET_DVR_GetFileByTime_V40() -> Saves raw stream chunks to /tmp/kvision_download_*.mp4 ]
                         |
                         v (Progress Timer polls NET_DVR_GetDownloadPos every 500ms)
[ Raw chunk download completes (100%) ]
                         |
                         v
[ Spawns background QProcess: "ffmpeg -y -i raw.mp4 -c copy final.mp4" ]
                         |
                         v
[ FFmpeg process exits (code 0) ]
                         |
                         v
[ Removes temporary /tmp files & emits downloadFinished(true, "Completed") ]
```

---

## 4. NVR Health Diagnostic Loop

```
+-------------------------------------------------------------+
|        NvrStatusManager (Triggered every 60s or checkNow)   |
+-------------------------------------------------------------+
                               |
                               v
               [ Spawns NvrStatusWorker in QThread ]
                               |
                               v
            [ Iterates configured NVRs in recordersJson ]
                               |
                               +---> [ HikvisionManager::getSession() ]
                               |
                               v
            [ NET_DVR_GetDVRWorkState_V30(lUserID, &workState) ]
                               |
        +----------------------+----------------------+
        | Check Conditions                            |
        v                                             v
[ dwDeviceStatic == 1 ] (CPU Overload)      [ dwHardDiskStatic in (2,3,5,8) ] (HDD Error)
[ dwDeviceStatic == 2 ] (Hardware Error)    [ dwHardDiskStatic == 4 ] (Unformatted)
[ lUserID < 0 ] (NVR Offline)               [ dwHardDiskStatic == 7 ] (HDD Full)
        |                                             |
        +----------------------+----------------------+
                               v
              [ Aggregates raw error list ]
                               v
       [ Applies mutedRecorders filter (User suppressed NVRs) ]
                               v
              [ Emits finished(errors, checkedRecorders) ]
                               v
            [ GUI updates warning badge in ToolBar ]
```

---

## 5. Multi-Process Configuration Synchronization

```
+--------------------------------+                  +--------------------------------+
|    Window A (Primary GUI)      |                  |   Window B (Auxiliary GUI)     |
+--------------------------------+                  +--------------------------------+
                |                                                   |
  User modifies layout or NVR                                       |
                |                                                   |
                v                                                   |
    [ Context::writeSetting() ]                                     |
                |                                                   |
                v                                                   |
      [ QSettings::sync() ]                                         |
                |                                                   |
                v Flushes to disk                                   |
    ~/.config/KVision/KVision.conf                                  |
                |                                                   |
                +-------------------------+-------------------------+
                                          |
                                          v (Linux inotify kernel event)
                               [ QFileSystemWatcher ]
                                          |
                                          v Emits fileChanged()
                             [ Context::configFileChanged ]
                                          |
                                          +---------------------------------+
                                          |                                 |
                                          v                                 v
                             [ Reloads QSettings Cache ]       [ Reloads QSettings Cache ]
                             [ Updates Active Layouts ]        [ Updates Active Layouts ]
```
