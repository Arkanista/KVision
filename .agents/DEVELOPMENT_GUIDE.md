# KVision Development Guide & SDK Gotchas

This document details domain-specific SDK rules, C data structures, error tables, and a diagnostic runbook for troubleshooting.

---

## 1. Hikvision SDK Domain Rules & Structures

### A. Logical vs Physical Channel Formula
In Hikvision NVRs, IP cameras do **NOT** map to index `1`. They start at `byStartDChan` (typically 33 for 32-channel DVRs/NVRs, or 65 for 64-channel units).

```cpp
DWORD realSdkChannel = channelId;
if (deviceInfo.struDeviceV30.byStartDChan > 0) {
    realSdkChannel = channelId + deviceInfo.struDeviceV30.byStartDChan - 1;
} else if (deviceInfo.struDeviceV30.byChanNum > 0 && channelId > deviceInfo.struDeviceV30.byChanNum) {
    realSdkChannel = deviceInfo.struDeviceV30.byStartDChan + (channelId - deviceInfo.struDeviceV30.byChanNum) - 1;
} else if (deviceInfo.struDeviceV30.byStartChan > 0) {
    realSdkChannel = channelId + deviceInfo.struDeviceV30.byStartChan - 1;
}
```

### B. Core SDK Data Structures
```cpp
// 1. Device Info on Login
NET_DVR_DEVICEINFO_V40 devInfo;
// Contains:
// devInfo.struDeviceV30.byChanNum      -> Analog channel count
// devInfo.struDeviceV30.byStartChan    -> First analog channel ID
// devInfo.struDeviceV30.byIPChanNum    -> IP channel count
// devInfo.struDeviceV30.byStartDChan   -> First digital IP channel ID

// 2. Playback By Time Parameters
NET_DVR_VOD_PARA vodPara;
vodPara.dwSize = sizeof(NET_DVR_VOD_PARA);
vodPara.struIDInfo.dwChannel = realSdkChannel;
vodPara.struBeginTime = startTime; // NET_DVR_TIME
vodPara.struEndTime = stopTime;   // NET_DVR_TIME
vodPara.hWnd = NULL; // 0 for callback mode

// 3. Work Status (Diagnostic monitoring)
NET_DVR_WORKSTATE_V30 workState;
// workState.dwDeviceStatic     -> 0: Normal, 1: CPU Overload, 2: Hardware Error
// workState.struHardDiskStatic -> Array of NET_DVR_DISKSTATE:
//   dwHardDiskStatic: 0=Active, 1=Sleeping, 2=Abnormal, 3=Dormant, 4=Unformatted, 7=Full
```

### C. SDK Error Code Table & Mitigation

| Error Code | Constant | Meaning | Action / Fix |
| :--- | :--- | :--- | :--- |
| `1` | `NET_DVR_PASSWORD_ERROR` | Bad username or password | Re-authenticate in NVR settings modal. |
| `7` | `NET_DVR_NETWORK_RECV_TIMEOUT` | Network timeout | Check camera IP/port and firewall routing. |
| `17` | `NET_DVR_PARAMETER_ERROR` | Struct parameter invalid | Verify `dwSize` is initialized on structs. |
| `23` | `NET_DVR_CHANNEL_ERROR` | Channel does not exist | **Recalculate `realSdkChannel` using `byStartDChan`!** |
| `29` | `NET_DVR_NOOPRAGH` | User has no permission | Check user permissions on NVR for channel. |
| `34` | `NET_DVR_NOSUPPORT` | Feature not supported | Fall back to HTTP ISAPI or RTSP mode. |
| `41` | `NET_DVR_MAX_USERNUM_ERROR` | Too many open sessions | Use `HikvisionManager::loginShared()` pool. |

---

## 2. Hikvision HTTP ISAPI Protocol Schemas

### Recording Search Request (`POST /ISAPI/ContentMgmt/search`)
```xml
<?xml version="1.0" encoding="utf-8"?>
<CMSearchDescription xmlns="http://www.hikvision.com/ver20/XMLSchema">
  <searchID>{UUID}</searchID>
  <trackList>
    <trackID>101</trackID> <!-- Channel ID * 100 + 1 -->
  </trackList>
  <timeSpanList>
    <timeSpan>
      <startTime>2026-08-28T00:00:00Z</startTime> <!-- UTC ISO8601 -->
      <endTime>2026-08-28T23:59:59Z</endTime>
    </timeSpan>
  </timeSpanList>
  <maxResults>1000</maxResults>
  <searchResultPostion>1</searchResultPostion>
  <metadataList>
    <metadataDescriptor>//recordType.meta.std-cgi.com</metadataDescriptor>
  </metadataList>
</CMSearchDescription>
```

### Search Response Example (`200 OK`)
```xml
<CMSearchResult xmlns="http://www.hikvision.com/ver20/XMLSchema">
  <searchID>{UUID}</searchID>
  <responseStatusStrg>OK</responseStatusStrg>
  <numOfMatches>1</numOfMatches>
  <matchList>
    <searchMatchItem>
      <trackID>101</trackID>
      <timeSpan>
        <startTime>2026-08-28T10:00:00Z</startTime>
        <endTime>2026-08-28T10:30:00Z</endTime>
      </timeSpan>
      <mediaSegmentDescriptor>
        <playbackURI>rtsp://.../Streaming/tracks/101?starttime=20260828T100000Z</playbackURI>
      </mediaSegmentDescriptor>
    </searchMatchItem>
  </matchList>
</CMSearchResult>
```

---

## 3. Diagnostic & Troubleshooting Runbook

### Issue 1: "Black Screen / Loading Spinner Infinite on RTSP Stream"
1. Verify camera URL formatting: `rtsp://[user]:[pass]@[ip]:[port]/Streaming/Channels/[ch]01` (Main) or `.../[ch]02` (Sub).
2. Check `rtsp_transport` option in settings (Switch between `tcp` and `udp`).
3. Launch with `./build/kvision --enable-logs` and inspect `~/.config/KVision/log/kvision_diagnostic.log` for FFmpeg decode errors.

### Issue 2: "Archive Playback Fails with SDK Error 23 on NVR"
1. Logical channel `1` on NVR is physical channel `33` or `65`.
2. Inspect log for: `Logical Chan: X -> Real SDK Chan: Y`.
3. Check `byStartDChan` returned by `deviceInfo.struDeviceV30.byStartDChan`.

### Issue 3: "High Memory Consumption After 24h of Operation"
1. Verify `Context::trimMemory()` (`malloc_trim(0)`) is being invoked on viewport layout change.
2. Confirm `PACKETS_LIMIT` (64) and `VIDEO_FRAMES_LIMIT` (8) are not being bypassed in custom builds.

### Issue 4: "Auxiliary Window Won't Open"
1. Verify `auxiliaryLimit` in `~/.config/KVision/KVision.conf` is greater than active count.
2. Check `/proc` process listing for zombie `./kvision --auxiliary` processes.

---

## 4. Build, Test & Run Command Reference

```bash
# 1. Full Build
cmake -B build -S .
cmake --build build -j$(nproc)

# 2. Run Main Instance
./build/kvision

# 3. Run with Diagnostic Logging
./build/kvision --enable-logs

# 4. Run Auxiliary Multi-Monitor Window
./build/kvision --auxiliary 1

# 5. Run Live Stream Diagnostic Tool
cmake --build build --target diagnose_live
./build/diagnose_live

# 6. Run Archive Playback Diagnostic Tool
cmake --build build --target diagnose_archive
./build/diagnose_archive

# 7. Recompile Translations
lupdate src -ts translations/*.ts
lrelease translations/*.ts
```
