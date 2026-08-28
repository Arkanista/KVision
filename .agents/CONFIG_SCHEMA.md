# KVision Configuration Schema & Key Dictionary

Configuration is stored in `~/.config/KVision/KVision.conf` (INI format).

---

## 1. Top-Level & General Settings (`[General]` / Root)

| Key | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `language` | `string` | `"system"` | UI language code (e.g. `"en"`, `"pl"`, or `"system"`). |
| `singleApplication` | `bool` | `true` | Enforce single main instance running at a time. |
| `auxiliaryLimit` | `int` | `1` | Max number of auxiliary multi-monitor windows (range: 0–3). |
| `allowSwappingViewports` | `bool` | `true` | Enable drag-and-drop camera swapping between grid tiles. |
| `enableContextMenu` | `bool` | `true` | Enable right-click context menu on camera tiles. |
| `enableRemoveCamera` | `bool` | `true` | Show option to clear camera from a tile. |
| `enableChangeViewportSettings`| `bool` | `true` | Allow per-viewport settings modal. |
| `enableStreamSelection` | `bool` | `true` | Allow switching between Main and Sub streams. |
| `lockGridSize` | `bool` | `true` | Lock matrix grid dimensions when switching views. |
| `snapshotPath` | `string` | `""` | Destination directory for PNG/JPG screenshots (empty = default Pictures). |
| `videoPath` | `string` | `""` | Destination directory for MP4 export clips (empty = default Videos). |
| `disableAudio` | `bool` | `false` | Global audio muting toggle. |
| `playbackOffsetSeconds` | `int` | `120` | Default rewind offset (in seconds) when opening archive playback. |
| `playbackTimelineHours` | `int` | `2` | Visible time span (in hours) on the archive timeline bar. |
| `enableDiagnosticLogs` | `bool` | `false` | Write FFmpeg & debug logs to `<config_dir>/log/kvision_diagnostic.log`. |

---

## 2. View & Viewport Preferences (`[View]` and `[Viewport]`)

| Section | Key | Type | Default | Description |
| :--- | :--- | :--- | :--- | :--- |
| `[View]` | `hideCursorWhenFullScreen` | `bool` | `true` | Auto-hide mouse cursor during inactive fullscreen. |
| `[View]` | `showChannelStatus` | `bool` | `true` | Show connection status icon on tiles. |
| `[View]` | `showCameraInfo` | `bool` | `true` | Display camera name and stream bitrate overlay. |
| `[View]` | `hoverControlIcons` | `bool` | `true` | Show playback and stream controls only on hover. |
| `[View]` | `showInfoOnHoverOnly` | `bool` | `false` | Hide camera title unless hovered. |
| `[View]` | `showTopBarByDefault` | `bool` | `true` | Keep top navigation bar visible. |
| `[Viewport]` | `noUnmuteWhenFullScreen` | `bool` | `false` | Do not automatically unmute audio on entering fullscreen. |

---

## 3. NVR Health Monitoring (`[NvrMonitoring]`)

| Key | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `enabled` | `bool` | `true` | Master toggle for background health checking. |
| `checkOffline` | `bool` | `true` | Alert when cameras/channels go offline. |
| `checkCpu` | `bool` | `true` | Alert on high NVR CPU load (>90%). |
| `checkHw` | `bool` | `true` | Alert on NVR hardware/fan/sensor faults. |
| `checkHdd` | `bool` | `true` | Alert on S.M.A.R.T. or HDD errors. |
| `checkUnformatted` | `bool` | `true` | Alert if unformatted storage drives exist. |
| `checkFull` | `bool` | `true` | Alert when HDD reaches full capacity without overwrite. |
| `mutedRecorders` | `QStringList` | `[]` | List of recorder names/IPs with suppressed alarms. |

---

## 4. Window Geometry (`[RootWindow]` / `[AuxiliaryWindow_<id>]`)

| Key | Type | Description |
| :--- | :--- | :--- |
| `width`, `height` | `int` | Window dimensions. |
| `x`, `y` | `int` | Screen coordinate position. |
| `fullScreen` | `bool` | Fullscreen state. |

---

## 5. JSON Schemas for Encapsulated Keys

### `[Hikvision]` $\to$ `recordersJson` (Array of NVR Objects)
```json
[
  {
    "name": "Warehouse NVR",
    "ip": "192.168.1.100",
    "port": 8000,
    "sdkPort": 8000,
    "httpPort": 80,
    "rtspPort": 554,
    "username": "admin",
    "password": "EncryptedOrPlainTextPassword",
    "cameras": [
      {
        "channelId": 1,
        "name": "Gate Entrance",
        "online": true,
        "streamType": 0
      }
    ]
  }
]
```

### `[ViewportsLayoutsCollection]` $\to$ `models` (Array of Grid Layouts)
```json
[
  {
    "name": "Main 2x2",
    "columns": 2,
    "rows": 2,
    "aspectRatio": "16:9",
    "items": [
      {
        "url": "rtsp://admin:pass@192.168.1.100:554/Streaming/Channels/101",
        "secondaryUrl": "rtsp://admin:pass@192.168.1.100:554/Streaming/Channels/102",
        "rowSpan": 1,
        "columnSpan": 1,
        "visible": 0,
        "volume": 0.0,
        "noUnmute": false
      }
    ]
  }
]
```
