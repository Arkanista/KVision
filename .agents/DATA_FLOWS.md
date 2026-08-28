# KVision Data Flows & Lifecycles

This document details the main data paths and execution lifecycles within KVision.

---

## 1. Live Video Streaming Flow

```
+------------------+       User selects / assigns camera
|  ViewportsLayout | ----------------------------------------+
+------------------+                                         |
         |                                                   v
         | Instantiates                              +---------------+
         +-----------------------------------------> |  Player.qml   |
                                                     +---------------+
                                                             |
                                      +----------------------+----------------------+
                                      | (Mode A: RTSP / FFmpeg)                     | (Mode B: Native SDK)
                                      v                                             v
                              +---------------+                             +------------------+
                              |  QmlAVPlayer  |                             | HikvisionPlayer  |
                              +---------------+                             +------------------+
                                      |                                             |
                   +------------------+------------------+                          | NET_DVR_RealPlay_V40
                   v                                     v                          v
          +-----------------+                   +------------------+         +---------------+
          |  QmlAVDemuxer   | (libavformat)     |   QmlAVDecoder   |         | HCNetSDK Core |
          +-----------------+                   +------------------+         +---------------+
                   |                                     |                          |
                   +------------------+------------------+                          v
                                      v                                      [ Direct Blit ]
                             [ OpenGL Frame Buffer ]                                |
                                      v                                             v
                             [ Screen Display Item ] <------------------------------+
```

### Key Steps:
1. **Assignment**: `ViewportsLayout.qml` loads the active grid from `ViewportsLayoutsCollectionModel`.
2. **Player Selection**: Each tile creates `Player.qml`, which determines whether to stream via RTSP (using `QmlAVPlayer`) or direct SDK (`HikvisionPlayer`).
3. **Demuxing & Decoding**: In RTSP mode, `QmlAVDemuxer` reads network packets into thread-safe queues, and `QmlAVDecoder` decodes them to YUV/RGB buffers.
4. **Rendering**: Frames are rendered directly to the Qt Quick scene graph using OpenGL or `QQuickPaintedItem`.

---

## 2. Archive Search & Playback Flow

```
[ User opens PlaybackWindow ]
          |
          v
[ Select Camera & Date ]
          |
          +---> [ HikvisionISAPI::searchRecordings() ]
                         |
                         v (HTTP Digest /ISAPI/ContentMgmt/search)
                [ NVR returns XML/JSON recording segments ]
                         |
                         v
                [ Segments parsed & sent to QML ]
                         |
                         v
                [ Timeline Bar renders colored recording spans ]
                         |
                         v User clicks time / presses Play
                [ HikvisionArchivePlayer::playAtTime(QDateTime) ]
                         |
                         +---> [ HikvisionManager::loginShared() ]
                         |
                         v
                [ NET_DVR_PlayBackByTime_V40() ]
                         |
       +-----------------+-----------------+
       | Stream Callbacks                 | Audio Callbacks
       v                                  v
 [ PlayDataCallBack() ]            [ AudioCallBack() ]
       |                                  |
       v                                  v
 [ DecCallBack() ] (YV12 frame)     [ QAudioOutput ] (PCM Sound)
       |
       v
 [ FrameBufferPool & YV12ToRGBTask ] (Worker thread)
       |
       v
 [ QQuickPaintedItem::paint() ] (Screen rendering)
```

### Key Steps:
1. **Segment Search**: `HikvisionISAPI` queries the NVR for available video chunks across 24 hours.
2. **Timeline Rendering**: Segments are bound to the QML timeline bar component for visual navigation.
3. **Shared Session Playback**: `HikvisionArchivePlayer` uses `HikvisionManager::loginShared()` to prevent opening redundant connections to the NVR.
4. **Zero-Allocation Conversion**: Decoded YV12 video frames are processed via `FrameBufferPool` to prevent heap fragmentation.
5. **Audio-Video Synchronization**: Audio samples are forwarded via `AudioCallBack` directly into `QAudioOutput`.

---

## 3. Video Download & Export Flow

```
[ User selects Time Range in DownloadDialog.qml ]
                    |
                    v
[ HikvisionDownloader::startDownload(recorderInfo, ch, start, end, targetPath) ]
                    |
                    v
[ Splits requested range into NVR-supported download segments ]
                    |
                    v (Loop over segments)
[ NET_DVR_GetFileByTime_V40() -> Saves raw stream to /tmp/kvision_*.mp4 ]
                    |
                    v (Progress timer checks download percentage)
[ Raw stream download completes ]
                    |
                    v
[ Spawns background QProcess: "ffmpeg -y -i input.mp4 -c copy final.mp4" ]
                    |
                    v
[ Emits downloadFinished(success, message) & Cleans temp files ]
```

---

## 4. NVR Health & Status Diagnostic Loop

```
+-------------------------------------------------------------+
|           NvrStatusManager (Background Timer / 60s)         |
+-------------------------------------------------------------+
                               |
                               v
               [ Spawns NvrStatusWorker in QThread ]
                               |
                               +---> Iterates configured NVRs
                               |
                               v
               [ NET_DVR_GetDVRConfig / NET_DVR_GET_WORK_STATUS ]
                               |
             +-----------------+-----------------+
             | Check items                       |
             v                                   v
   [ HDD Status: Full / Error ]         [ CPU & Network Load ]
   [ Unformatted Disks ]                [ Offline Channels / Cameras ]
             |                                   |
             +-----------------+-----------------+
                               v
               [ Collects raw errors list ]
                               |
                               v
               [ Applies user Muting filters ]
                               |
                               v
         [ Emits errorsChanged() & Updates UI Status Badge ]
```

---

## 5. Multi-Process Configuration Synchronization

```
+-----------------------------+               +-----------------------------+
|     Window A (Main GUI)     |               |   Window B (Auxiliary GUI)  |
+-----------------------------+               +-----------------------------+
               |                                             ^
  User saves setting or layout                               |
               |                                             |
               v                                             |
   [ QSettings::setValue() ]                                 |
               |                                             |
               v                                             |
   [ QSettings::sync() ]                                     |
               |                                             |
               v Writes to disk                              |
    ~/.config/KVision/KVision.conf                           |
               |                                             |
               | Linux inotify event                         |
               v                                             |
   [ QFileSystemWatcher ] -----------------------------------+
                                   Triggers onConfigFileChanged()
                                   Reloads QSettings cache & models
```
