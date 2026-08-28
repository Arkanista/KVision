# KVision System Architecture

## 1. High-Level Overview
**KVision** is a high-performance desktop CCTV client designed for Linux (with modular architecture adaptable for other platforms). It provides real-time surveillance video playback, multi-monitor multi-window viewing, Hikvision NVR/camera discovery and diagnostics, synchronized archive search and playback with a 24-hour timeline, and automated video clip exporting.

### Technology Stack
* **Language**: C++17 & QML / Qt Quick 2
* **Framework**: Qt 5.15+ (GUI, Quick, Network, Core, Multimedia, Labs.Settings)
* **Video Engine**:
  * **QmlAV**: Custom internal multimedia engine based on **FFmpeg** (`libavcodec`, `libavformat`, `libavutil`, `libswscale`, `libswresample`).
  * **Hikvision HCNetSDK**: Native C/C++ SDK (`hcnetsdk_compat.h`, `libhcnetsdk.so`, `HCNetSDKCom`) for direct NVR interaction, PTZ, and native archive playback.
* **Build System**: CMake (minimum 3.14) with GNUInstallDirs.

---

## 2. Process & Window Model

### Single-Instance & Multi-Process Architecture
* **Main Process**:
  * Handles primary user interface (`RootWindow.qml`), global state, NVR discovery, and health monitoring (`NvrStatusManager`).
  * Uses [`SingleApplication`](file:///home/robert/cctv/kvision/src/singleapplication.h) to enforce single main instance execution.
* **Auxiliary Processes (`--auxiliary <id>`)**:
  * Spawned from the main window (e.g. via [`Context::startAuxiliaryProcess()`](file:///home/robert/cctv/kvision/src/context.cpp#L44)).
  * Allows detached grid windows for multi-monitor setups.
  * Checks system process count via [`countAuxiliaryProcesses()`](file:///home/robert/cctv/kvision/src/main.cpp#L208) to respect `auxiliaryLimit` (configurable in settings, default: 1, max: 3).
  * Runs [`AuxiliaryWindow.qml`](file:///home/robert/cctv/kvision/src/AuxiliaryWindow.qml) in its own event loop and OpenGL/render thread.

---

## 3. Video Subsystems & Pipelines

KVision employs two complementary video decoding pathways:

```
+-------------------------------------------------------------------------+
|                                KVision                                  |
+------------------------------------+------------------------------------+
|            Live Stream             |          Archive / Playback        |
+------------------------------------+------------------------------------+
|                                    |                                    |
|  [RTSP URL / General Stream]       |  [Hikvision NVR Storage]           |
|                v                   |                v                   |
|        QmlAV Engine (FFmpeg)       |    Hikvision SDK (HCNetSDK)        |
|  * QmlAVDemuxer                    |  * NET_DVR_PlayBackByTime_V40      |
|  * QmlAVDecoder                    |  * DecCallBack (YV12 -> RGB)       |
|  * QmlAVVideoBuffer / HW Output    |  * AudioCallBack -> QAudioOutput   |
|  * Render to QQuickItem            |  * Render via QQuickPaintedItem    |
|                                    |                                    |
+------------------------------------+------------------------------------+
```

### A. QmlAV (FFmpeg Player)
* Located in [`src/qmlav/`](file:///home/robert/cctv/kvision/src/qmlav/).
* Highly optimized threaded decoder designed specifically for low-latency RTSP CCTV feeds.
* Features hardware decoding support (`qmlavhwoutput.cpp`), thread-safe queues (`qmlavwaitingqueue.h`), audio resampling, and fast frame dropping to maintain real-time sync.

### B. Hikvision HCNetSDK Integration
* [`HikvisionManager`](file:///home/robert/cctv/kvision/src/hikvisionmanager.h): Central singleton managing SDK initialization, device login sessions, thread-safe PTZ command queue (`ptzWorkerLoop`), and asynchronous camera discovery (`discoverCamerasAsync`).
* [`HikvisionPlayer`](file:///home/robert/cctv/kvision/src/hikvisionplayer.h): Direct live video stream item rendering Hikvision channels.
* [`HikvisionArchivePlayer`](file:///home/robert/cctv/kvision/src/hikvisionarchiveplayer.h):
  * Archive player with hardware/software decoding of YV12 frames to RGB.
  * Includes a pre-allocated [`FrameBufferPool`](file:///home/robert/cctv/kvision/src/hikvisionarchiveplayer.h#L136-L148) to eliminate heap allocations during decoding.
  * Real-time audio stream decoder routing PCM audio to [`QAudioOutput`](file:///home/robert/cctv/kvision/src/hikvisionarchiveplayer.h#L161).
* [`HikvisionISAPI`](file:///home/robert/cctv/kvision/src/hikvisionisapi.h): High-level HTTP/REST client using Digest authentication for searching recordings by timeline/month and fetching device metadata.
* [`HikvisionDownloader`](file:///home/robert/cctv/kvision/src/hikvisiondownloader.h): Downloads raw video streams via SDK chunking and converts them to standard MP4 using an asynchronous FFmpeg subprocess.

---

## 4. Configuration & State Management

### INI + JSON Architecture
* Format: **INI standard** managed by Qt's `QSettings` (`QSettings::IniFormat`).
* Default Path: `~/.config/KVision/KVision.conf` (Linux).
* Data Division:
  * Key-value pairs for UI toggles, geometry, and paths.
  * Encapsulated JSON strings (`Hikvision/recordersJson`, `ViewportsLayoutsCollection/models`) for deep dynamic tree data.
* **Automatic Backup**: On startup, [`Config::Config()`](file:///home/robert/cctv/kvision/src/config.cpp#L22-L28) copies `KVision.conf` to `KVision.conf.bak`.
* **Multi-Process Hot-Reload**: [`Context`](file:///home/robert/cctv/kvision/src/context.cpp#L146-L160) attaches a `QFileSystemWatcher` to the config file. When one process or external editor saves changes, `configFileChanged` signals are emitted to synchronize all active windows.

---

## 5. Performance & Memory Management

* **`Context::trimMemory()`**: Calls `malloc_trim(0)` on glibc systems upon minimizing, hiding, or changing window states to release cached memory back to the operating system.
* **FrameBuffer Pooling**: Decoded video frames in archive player use fixed pools to avoid GC / heap fragmentation.
* **Thread Safety**: All network queries (ISAPI), channel discovery (`QThread`), PTZ worker threads, and FFmpeg decoding run in separate worker threads to keep the QML GUI thread at a stable 60 FPS.
