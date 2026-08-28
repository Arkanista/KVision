# KVision Architecture & Technical Specification

KVision is a multi-monitor, high-performance Video Management System (VMS) client designed for Linux, built with **Qt 5.15+ (Quick/QML)**, **C++17**, **FFmpeg**, and **Hikvision HCNetSDK / ISAPI**.

---

## 1. System Technology Stack

```
+---------------------------------------------------------------------------------------+
|                                    User Interface                                     |
|                       Qt Quick 2.12 / QML / Qt Graphical Effects                      |
|      (RootWindow, AuxiliaryWindow, PlaybackWindow, ViewportsLayout, Player OSD)        |
+---------------------------------------------------------------------------------------+
                                           |
                                QML / C++ MetaObject Bridge
                                           |
+---------------------------------------------------------------------------------------+
|                                      C++ Core                                         |
|   Context (Singleton) | SingleApplication (IPC) | SystemStats | NvrStatusManager      |
|   ViewportsLayoutModel | ViewportsLayoutsCollectionModel | ThumbnailProvider           |
+---------------------------------------------------------------------------------------+
                |                                                  |
                v                                                  v
+--------------------------------------+   +--------------------------------------------+
|        QmlAV Multimedia Engine       |   |       Hikvision Subsystem (SDK & ISAPI)    |
| - QmlAVDemuxer (libavformat)         |   | - HikvisionManager (Session pooling & PTZ) |
| - QmlAVDecoder (libavcodec / HW)     |   | - HikvisionPlayer (Live SDK stream)        |
| - QmlAVAudioIODevice (QAudioOutput)  |   | - HikvisionArchivePlayer (DecCallBack YV12)|
| - QmlAVHWOutput (VAAPI / GLX / CUDA) |   | - HikvisionISAPI (Digest Auth REST Search) |
| - Frame Queues & Zero-Latency Sync   |   | - HikvisionDownloader (SDK GetFileByTime)  |
+--------------------------------------+   +--------------------------------------------+
                |                                                  |
                v                                                  v
+--------------------------------------+   +--------------------------------------------+
|         FFmpeg 4.x / 5.x / 6.x       |   |             libhcnetsdk.so Core            |
|       (libavformat, libavcodec,      |   |            (libHCCore.so, libssl,          |
|        libavutil, libswscale)        |   |             libPlayCtrl.so)                |
+--------------------------------------+   +--------------------------------------------+
```

---

## 2. Multi-Process Architecture & IPC

KVision employs a multi-process architecture to support multi-monitor installations with complete window isolation and native Wayland/X11 window manager independence:

```
                  +----------------------------------------------+
                  |                 Linux OS                     |
                  +----------------------------------------------+
                                         |
                 +-----------------------+-----------------------+
                 |                                               |
                 v                                               v
   +---------------------------+                   +---------------------------+
   |   Primary Process (GUI)   |                   | Auxiliary Process 1 (GUI) |
   | - SingleApplication Lock  |                   | - Launched: --auxiliary 1 |
   | - LocalSocket Server Host |                   | - Displays AuxiliaryWindow|
   | - Displays RootWindow     |                   | - Direct OpenGL rendering |
   +---------------------------+                   +---------------------------+
                 |                                               |
                 +-----------------------+-----------------------+
                                         |
                                         v
                      +-------------------------------------+
                      |    ~/.config/KVision/KVision.conf   |
                      |   (Shared INI Config with inotify)  |
                      +-------------------------------------+
                                         ^
                                         |
                            +--------------------------+
                            |   QFileSystemWatcher     |
                            | (Monitors file mutation) |
                            +--------------------------+
```

### Process Roles:
1. **Primary Instance**:
   * Initializes [`SingleApplication`](file:///home/robert/cctv/kvision/src/singleapplication.h), binding to a Unix domain socket `kvision-kvision-socket-<UID>`.
   * Hosts main controls, NVR camera tree (`SideBar.qml`), and primary video viewport matrix.
   * On shutdown or crash, cleans stale socket descriptors.
2. **Auxiliary Windows (`--auxiliary <id>`)**:
   * Spawned via `Context::startAuxiliaryProcess()`.
   * Bypasses the `SingleApplication` primary mutex check.
   * Spawns independent QML engine and OpenGL context, allowing dedicated GPU scheduling across separate physical displays.
   * Monitored via `/proc` in `main.cpp::countAuxiliaryProcesses()` against `auxiliaryLimit` (max 3).
3. **Cross-Process Hot-Reloading**:
   * Both primary and auxiliary processes register `~/.config/KVision/KVision.conf` with [`QFileSystemWatcher`](file:///home/robert/cctv/kvision/src/context.cpp#L25).
   * File writes trigger debounced signal `Context::configFileChanged()`. All active processes reload models and camera matrices dynamically without dropped frames.

---

## 3. Multimedia Subsystem Deep Dive

### 3.1. `QmlAV` Engine Architecture (RTSP & FFmpeg)
The `QmlAV` engine is a dedicated multithreaded audio/video pipeline built on top of FFmpeg:

```
[ RTSP Stream URL ]
       |
       v
+------------------+     av_read_frame()     +--------------------+
|   QmlAVDemuxer   | ----------------------> |   AVPacket Queue   | (Limit: 64 packets)
|  (Loader Thread) |                         +--------------------+
+------------------+                                   |
       |                                               v
       | Interrupt timeout: 5000ms           +--------------------+
       |                                     |    QmlAVDecoder    | (Thread Count: 1)
       |                                     +--------------------+
       |                                               |
       +-----------------------------------------------+
                               |
               +---------------+---------------+
               | Video                         | Audio
               v                               v
       +---------------+               +---------------+
       | AVFrame Queue | (Limit: 8)    | AVFrame Queue | (Limit: 32)
       +---------------+               +---------------+
               |                               |
               v                               v
       +---------------+               +---------------+
       | QmlAVHWOutput | (VAAPI/GLX)   |  QAudioOutput | (PCM Sample Format)
       +---------------+               +---------------+
               |
               v
       [ Qt Video Surface / OpenGL Scene Graph ]
```

#### Key Design Decisions in `QmlAV`:
* **Zero-Latency Realtime Pacing**: When streaming RTSP (`m_context->clock.realTime = true`), presentation time delays are bypassed to eliminate streaming lag. Frames are rendered immediately upon decode.
* **Bounded Packet Queues**:
  * Packet queue limit: `PACKETS_LIMIT = 64`.
  * Video frame queue limit: `VIDEO_FRAMES_LIMIT = 8`.
  * Audio frame queue limit: `AUDIO_FRAMES_LIMIT = 32`.
  * If a decoder lags behind network delivery, overflowing frames are dropped (`m_counters.framesDiscarded++`) to prevent runaway RAM growth.
* **Hardware Acceleration Auto-Negotiation**:
  * Supported types: `AV_HWDEVICE_TYPE_VAAPI`, `AV_HWDEVICE_TYPE_CUDA`, `AV_HWDEVICE_TYPE_VDPAU`.
  * `QmlAVVideoDecoder::negotiatePixelFormatCb()` checks hardware contexts. If HW decoding fails or format is unsupported, it falls back to native Qt pixel formats without interrupting playback.
* **Single Thread per Decoder**: `m_avCodecCtx->thread_count = 1` prevents thread explosion on high-core-count machines when rendering 16 or 36 camera grids simultaneously.

---

### 3.2. Hikvision HCNetSDK & ISAPI Subsystem

For native Hikvision archive search, playback, PTZ, and diagnostic telemetry, KVision integrates directly with the Hikvision C SDK (`libhcnetsdk.so`) and HTTP ISAPI:

```
+-------------------------------------------------------------------------------+
|                             Hikvision Subsystem                               |
+-------------------------------------------------------------------------------+
           |                                     |                     |
           v                                     v                     v
   [ HikvisionISAPI ]                  [ HikvisionArchivePlayer ]  [ NvrStatusManager ]
   (HTTP REST / XML)                   (NET_DVR_PlayBackByTime)    (NET_DVR_GetDVRWorkState)
           |                                     |                     |
           v                                     v                     v
- Search 24h recordings                - Stream DecCallBack (YV12) - HDD status / bad sectors
- Search monthly calendar marks        - AudioCallBack (PCM)       - CPU & hardware load
- Digest Auth session management       - Speed control (-8x..+8x)  - Offline channel alerts
```

#### Shared Session Pool ([`HikvisionManager`](file:///home/robert/cctv/kvision/src/hikvisionmanager.h)):
* NVR hardware limits concurrent user logins (typically max 128 connections).
* `HikvisionManager::loginShared()` caches `lUserID` sessions by `IP:Port:User:Pass`. Multiple archive players and status monitors querying the same NVR share a single authenticated socket.

#### Zero-Copy Frame Buffering ([`HikvisionArchivePlayer`](file:///home/robert/cctv/kvision/src/hikvisionarchiveplayer.h)):
* `DecCallBack` outputs decoded frames in `YV12` pixel format.
* A custom `FrameBufferPool` allocates reusable memory blocks.
* `YV12ToRGBTask` converts pixels to `QImage::Format_RGB32` in a background worker thread, scheduling a lightweight `QQuickPaintedItem::update()` call on the GUI thread.

---

## 4. Memory Management & Garbage Collection

CCTV applications streaming multiple high-resolution video feeds are prone to heap fragmentation:

1. **Explicit glibc Memory Purging (`trimMemory()`)**:
   * When closing windows, changing grid layouts, or leaving fullscreen, [`Context::trimMemory()`](file:///home/robert/cctv/kvision/src/context.cpp#L46) executes:
     ```cpp
     #if defined(Q_OS_LINUX) && defined(__GLIBC__)
         malloc_trim(0);
     #endif
     ```
   * This forces glibc to release cached, freed arena pages back to the Linux kernel immediately.
2. **Deferred QML Garbage Collection**:
   * Modal dialogs (`NvrCamerasWindow.qml`, `DownloadDialog.qml`) trigger `gc()` and `rootWindow.triggerGcDeferred()` upon closure, reclaiming JavaScript heap objects.
3. **Thumbnail Cleanup**:
   * [`ThumbnailProvider`](file:///home/robert/cctv/kvision/src/thumbnailprovider.h) limits cached camera thumbnails to active channels and evicts expired snapshots from RAM.
