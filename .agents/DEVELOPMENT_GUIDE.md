# KVision Development Guide & SDK Gotchas

This guide contains critical domain rules, SDK caveats, and workflow commands to avoid common implementation pitfalls.

---

## 1. Hikvision SDK Rules & Domain Gotchas

### A. Logical Channel vs SDK Physical Channel Numbering
* **Problem**: In Hikvision NVRs, IP cameras do **NOT** start at channel `1`.
* **Formula**:
  ```cpp
  // IP cameras on NVRs start at byStartDChan (typically channel 33 or 65)
  if (deviceInfo.struDeviceV30.byStartDChan > 0) {
      m_realSdkChannel = m_channelId + deviceInfo.struDeviceV30.byStartDChan - 1;
  } else {
      m_realSdkChannel = m_channelId + deviceInfo.struDeviceV30.byStartChan - 1;
  }
  ```
* **Rule**: Always map `channelId` (1..N) through `byStartDChan` before calling `NET_DVR_PlayBackByTime_V40`, `NET_DVR_GetFileByTime_V40`, or `NET_DVR_RealPlay_V40`.

### B. SDK Callbacks & Thread Safety
* **Problem**: Callbacks like `DecCallBack`, `PlayDataCallBack`, and `AudioCallBack` are executed on native C-threads spawned by `libhcnetsdk.so`.
* **Rules**:
  * **Never** touch Qt Quick Scene Graph / QML items directly from SDK callbacks.
  * Use pre-allocated thread-safe buffers (`FrameBufferPool`) or post tasks to the GUI thread via:
    ```cpp
    QMetaObject::invokeMethod(this, [this, data]() {
        // Safe execution on Qt Event Loop / GUI thread
    }, Qt::QueuedConnection);
    ```
  * Always protect shared data structures with `std::mutex` or `std::atomic`.

### C. Audio PCM Format & Dynamic Sample Rate
* Hikvision audio streams send raw PCM data (typically 8000 Hz or 16000 Hz, 16-bit Mono/Stereo).
* [`HikvisionArchivePlayer`](file:///home/robert/cctv/kvision/src/hikvisionarchiveplayer.h) dynamically detects sample rate changes and reinitializes `QAudioOutput` without interrupting video playback.

### D. Memory Management & `trimMemory()`
* Video decoders allocate and release large frame buffers. On Linux glibc, freed memory may remain cached in the process arena.
* Calling [`Context::trimMemory()`](file:///home/robert/cctv/kvision/src/context.cpp#L46) invokes `malloc_trim(0)`, forcing glibc to release unused memory back to the OS when minimizing or stopping streams.

---

## 2. Build & Development Commands Cheat-Sheet

### Standard Build
```bash
# Configure & build all targets
cmake -B build -S .
cmake --build build -j$(nproc)
```

### Running the Application
```bash
# Normal execution
./build/kvision

# Run with diagnostic file logging enabled
./build/kvision --enable-logs

# Run as auxiliary multi-monitor window (ID 1)
./build/kvision --auxiliary 1

# Specify custom configuration file
./build/kvision -c /path/to/custom_kvision.conf

# Simulate first-run setup wizard
./build/kvision --first-run
```

### Diagnostic Tools
```bash
# Build & run live stream diagnostic tool
cmake --build build --target diagnose_live
./build/diagnose_live

# Build & run archive playback diagnostic tool
cmake --build build --target diagnose_archive
./build/diagnose_archive
```

### Translations (i18n)
```bash
# Update translation source files (.ts)
lupdate src -ts translations/*.ts

# Compile translation binaries (.qm)
lrelease translations/*.ts
```
