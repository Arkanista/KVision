# Changelog

All notable changes to this project will be documented in this file.

## [2.8.4] - 2026-11-26

### Bug Fixes & Stability
* **Archive Playback Frame Safety (YV12 Buffer & Dimensions):**
  * *Before:* Corrupted, padded, or odd-dimension video frames from the Hikvision decoder could overflow the frame buffer and crash archive playback.
  * *Now:* Frame dimensions are strictly validated (bounded and even) using checked 64-bit math, memory allocation failures are caught safely, and only exact YV12 plane bytes are copied — preventing archive decoder memory corruption and crashes.
* **Reliable Multi-Camera Archive Sessions (Concurrent Login & Session Isolation):**
  * *Before:* Opening multiple archive cameras from the same NVR at the same time could trigger duplicate logins, leak NVR user slots, and leave wrong reference counts; an error on one camera could also force-logout the shared session and disconnect sibling archive windows.
  * *Now:* Concurrent logins to the same recorder are serialized into a single shared session, and failed sessions are retired safely without interrupting other active archive windows.
* **Immediate Recorder Credential Updates (Username & Password Cache):**
  * *Before:* Changing a recorder's username or password in settings kept reusing the old cached SDK session (matched only by IP and port) until KVision was restarted.
  * *Now:* Session lookup verifies IP, port, username, and password — credential changes take effect immediately without a restart.
* **Accurate Recording Download Error Detection & Startup Safety:**
  * *Before:* If a recording download failed mid-way with an SDK or network error (`pos < 0` or `pos == 200`), partial files larger than 4 KB were mistakenly marked as successful and converted into truncated MP4s; downloads started immediately at launch could also race SDK initialization, and search structs were uninitialized.
  * *Now:* SDK/network errors and mid-download stalls fail cleanly and remove incomplete temporary files (while keeping near-end NVR stall handling), downloads wait for SDK initialization, and search results are zero-initialized and date-validated.
* **Cross-Platform Auxiliary Window Limit & Custom Config (`-c`) Single-Instance Support:**
  * *Before:* The auxiliary window limit (`auxiliaryLimit`) relied on Linux `/proc` scanning, so it did not work on Windows and could race when opening windows rapidly; launching with `-c`/`--config` ignored `singleApplication` from that custom file.
  * *Now:* Auxiliary window slots use atomic cross-platform `QLockFile` locks that work identically on Windows and Linux (and recover cleanly after a crash), while keeping each auxiliary window as an independent process, and single-instance checks read the custom `-c`/`--config` file.
* **Smoother Archive Controls, FPS Counter & No Brief Red "No Recording" Flash:**
  * *Before:* Playback state (`isPlaying`), playback speed, and FPS counters were updated across threads without atomic synchronization, and synchronous multi-camera archive playback could briefly flash a red "No recording" banner before video appeared.
  * *Now:* Playback state, speed, and FPS updates are thread-safe (`std::atomic` with GUI-thread FPS resets), and archive status messages wait cleanly during initial seek, segment search, and active stream startup.
* **Lower Idle CPU Usage in Live View (Legacy Mock Player Cleanup):**
  * *Before:* Every camera tile created a hidden legacy `HikvisionPlayer` mock with a 25 Hz timer running continuously in the background (and its fallback path could invoke an invalid SDK handle or add synthetic network traffic).
  * *Now:* The mock player is loaded lazily only when real streams are explicitly disabled, stops its timer whenever hidden, and never touches real SDK handles or network statistics.
* **Linux Flatpak & RPM Packaging Fixes (included in `v2.8.4`):**
  * *Before:* Flatpak and RPM packages could fail to launch (`libhcnetsdk.so` `INSTALL_RPATH` pointed to `/app/app/lib/kvision` or `/usr/usr/lib64/kvision`), and Flatpak lacked H.265 (HEVC) decoding and SHA-256 RTSP Digest authentication due to the runtime's stripped FFmpeg 7.x (#16).
  * *Now:* `INSTALL_RPATH` resolves cleanly for all packaging prefixes, and Flatpak bundles full FFmpeg 9.1 with H.265/HEVC decoding, VAAPI hardware acceleration, and native SHA-256 RTSP Digest support.

## [2.8.3] - 2026-11-25

### Bug Fixes
* **Crash Fix During Thumbnail Generation:** Fixed memory alignment, frame format validation, and multi-thread cache/file access in `ThumbnailProvider` that could cause crashes on Windows (and Linux) when generating camera thumbnails while live view is active.
* **Clean Startup & Panel Window Fix:** Prevented the *Panel* settings window from auto-opening empty during startup before the main window finishes initializing (e.g., after an unexpected crash).

## [2.8.2] - 2026-11-24

### Bug Fixes
* **Reliable Settings Persistence & Multi-Window Sync:** Fixed an issue where settings such as *Disable audio handling completely* and *Disable viewport zoom animation* could revert to their default unchecked state when closing auxiliary windows or restarting after an update. Settings changed in any window now save directly and stay synchronized across all open windows.

## [2.8.1] - 2026-11-24

### Minor Enhancements
* **Rename Cameras Directly from Live View:** Added a *Rename* option to the camera right-click menu (for Hikvision cameras) with a clean popup dialog, plus a toggle in *Settings → User Interface → Context Menu Settings*.
* **Clearer Disabled Menu Options:** Improved the viewport right-click menu so unavailable options stay clearly readable in a dimmed gray shade instead of blending into the background, and unified the hover highlight color.
* **Improved Layouts Menu Organization:** Moved *Layout Groups* into a sub-tab under *Layouts* and placed *NVR Views Layouts (grid views)* at the top of the *Layouts* page for quicker access.
* **Translated Camera Count Label:** Localized the camera count label in the *Add camera* submenu across all supported languages.
* **Consistent Dialog Footers & Adaptive Buttons:** Unified the footer bar and button sizing across the Rename Camera, Viewport Settings, NVR Status, and Snapshot Saved dialogs so buttons automatically expand for longer translations, added the recorder name to the Rename Camera dialog, and updated Reset to preview the original name before confirming.

## [2.8.0] - 2026-11-23

### New Features & Improvements
* **Quick Camera Search (`Ctrl+F` / `Ctrl+S`):** Added a floating camera search window accessible from the top toolbar, the viewport context menu (*Add camera → Search...*), and `Ctrl+F` / `Ctrl+S`. Supports live filtering by camera name (custom or system), recorder name, and IP, showing thumbnails, assigned view names, and one-click actions to highlight the camera on layouts, open 1×1 archive playback, or assign it to the selected viewport.
* **Custom Layout Badge Colors:** Added a *Color* picker in *Layouts* allowing each layout button on the top bar (as well as badges in *Layout Groups* and search results) to use a custom accent color.
* **User Interface Sub-Tab & Badge Font Size:** Moved *Context Menu Settings* and *User Interface Settings* into a dedicated *User Interface* sub-tab under *Settings*, added a *Viewport info badge font size* (`1–72 px`) option applied to both live and archive viewports, and unified option label font sizes.
* **Archive & Context Menu Polish:** Updated the archive window top bar to respect the *Top bar background transparency* setting, modernized the `+` button in the archive camera list, and added icons to all items in the viewport right-click menu.

## [2.7.14] - 2026-11-22

### Localization & Bug Fixes
* **Translation Catalogs (`translations/*.ts`, `translations/*.qm`):**
  * Fixed camera viewport Stream selection labels where Polish text had leaked into non-Polish catalogs (#15).
  * Restored missing weekday abbreviations (`LNG_00166`–`LNG_00172`) in `DownloadDialog` and the recorder reorder tooltip (`LNG_00631`) in `NvrSettingsPanel`.
  * Repaired spaced Qt placeholders (such as `% 1`) so download progress, camera counts, and other dynamic values substitute properly.
  * Translated remaining untranslated English strings and improved Czech CCTV terminology across all 23 language catalogs.

## [2.7.13] - 2026-11-22

### Bug Fixes & Portability
* **AppImage RTSP SHA-256 Digest Authentication (`tools/build_appimage.sh`, `tools/patches/ffmpeg-4.4.6-digest.diff`):**
  * Backported RFC 7616 SHA-256 RTSP Digest authentication support to the bundled FFmpeg 4.4 `libavformat` library in AppImage builds, fixing `401 Unauthorized` ("No data to display") errors on Hikvision NVRs configured with SHA-256 or mixed MD5/SHA-256 Digest challenges (#14).
  * Added automated CI verification (`tools/test_rtsp_digest.py`) in `.github/workflows/build-appimage.yml` testing the extracted AppImage's bundled `ffmpeg` against MD5-only, SHA-256-only, and mixed Digest challenges.

## [2.7.12] - 2026-11-19

### Bug Fixes & Portability
* **Clean-Install Startup Crash (`RootWindow`, `Context`):**
  * Fixed a critical crash (`SIGSEGV` stack overflow) when launching KVision on a clean system or fresh user profile without an existing `KVision.conf` file (which also caused the `v2.7.11` AppImage verification to exit immediately before showing a window).
  * Deferred and coalesced `configFileChanged` notifications in `Context::scheduleConfigFileChanged()` onto the event loop instead of emitting synchronously inside `Context::writeSetting()`, added a re-entrancy guard in `RootWindow.qml`'s `onConfigFileChanged()`, and consolidated AV format option migrations so migration flags are persisted before updating `defaultAVFormatOptions`.
* **Linux & AppImage Portability (`CMakeLists.txt`, `qmlav`):**
  * Removed the unused `libavdevice` linkage (`avdevice_register_all()` on local files) from `QmlAVDemuxer`, CMake targets, and Debian/Ubuntu/AppImage dependency lists so `kvision` no longer pulls in `libjack.so.0` on minimal Linux installations or AppImage environments.

## [2.7.11] - 2026-11-18

### Features & Improvements
* **NVR Recorder Drag-and-Drop Reordering (`NvrSettingsPanel`, `ViewportsLayout`):**
  * Added animated drag-and-drop reordering for configured NVR recorders in *Settings → NVR Recorders* with live push-apart spacing and drop target boundaries.
  * Ensured instant drag handle readiness upon opening the settings panel using direct coordinate tracking.
  * Synchronized recorder order with the viewport right-click context menu under the **Add camera** submenu for immediate access to camera grids.
* **Camera Grid Multi-Selection & Batch Adding (`NvrCamerasWindow`):**
  * Added selection checkboxes to each camera tile in the NVR camera browser.
  * Added quick action buttons to batch add either all discovered channels or only selected channels to the active layout grid, prioritizing unfilled viewports.
* **Thumbnail Generation Progress & Cascading Cleanup (`ThumbnailProvider`, `NvrSettingsPanel`, `NvrCamerasWindow`):**
  * Added automatic background thumbnail generation upon adding a recorder, complete with live progress percentage indicators on recorder cards.
  * Added complete cascading recorder deletion that purges disk and memory thumbnails, un-mutes notification states, invalidates playback caches, and cleans custom viewports referencing the deleted IP.
* **Persistence & Synchronization Fixes (`RootWindow`, `context.cpp`, `nvrstatusmanager.cpp`):**
  * Fixed NVR recorder order persistence and prevented order reversion when opening the NVR Status dialog.
  * Synchronized recorder reordering instantly across auxiliary windows (`--auxiliary`) and external configuration watchers.
  * Eliminated conflicting `QML Settings` bindings that could overwrite `Hikvision/recordersJson` during application shutdown or settings sync.
  * Added deduplication when adding or modifying NVR recorders to reuse existing view layouts without creating duplicate tabs.

## [2.7.10] - 2026-11-18

### Bug Fixes & Versioning
* **Startup View Restoration & Strict Hidden-View Exclusion (`RootWindow`, `SideBar`, `ReorderableViewRow`, `ViewGroupsPanel`, `AuxiliaryWindow`):**
  * Fixed active layout restoration on application startup so KVision reliably opens the last active view instead of resetting to index `0`: guarded `onCountChanged`, `stackLayout.onCurrentIndexChanged`, `saveTimer`, and `flushSettingsToDisk()` behind `isStartupComplete`, read the persisted `MainLayout/currentIndex` directly before completion, and kept `windowLayoutSettings.currentIndex` synchronized during drag-and-drop `moveLayout()` reordering.
  * Enforced strict layout visibility rules across startup restoration, CLI `-p` selection, top-bar buttons, `SideBar` preset rows, `AuxiliaryWindow`, external config file synchronization (including `--auxiliary` windows via `syncEndTimer`), and `Alt+Left` / `Alt+Right` / `Alt+1..9` shortcuts: layouts marked with `visible: false` are never activated or proposed, falling back automatically to the first visible layout (or `-1` with dark canvas & null-safe `Utils.currentLayout()` / `Utils.currentModel()` guards if all layouts are hidden).
  * Disabled and dimmed the activate button (with hidden tooltip) for invisible layouts in `ReorderableViewRow` and immediately switched to the first visible layout when turning off visibility of the active view in `SideBar` or `ViewGroupsPanel`.
* **Patch Versioning Convention (`CMakeLists.txt`, `packaging/arch/PKGBUILD`):**
  * Dropped the `-X` release suffix from application versioning (`VER_REL=0` by default in `CMakeLists.txt` and removed `-DVER_REL` from `PKGBUILD`); all patch releases increment the third version number (`2.7.10`).

## [2.7.9] - 2026-11-17

### Features, UI & Documentation
* **View Groups, Collapsible Dock Boxes & Top Bar Sequence Customization (`ViewGroupsPanel`, `TopBarViewsArea`, `TopBarViewDelegate`, `TopBarViewButton`, `RootWindow`, `AuxiliaryWindow`):**
  * Added a dedicated **Layout Groups** tab in the Settings sidebar (`ViewGroupsPanel`) allowing custom layouts, NVR views, and auto-generated NVR camera grids to be grouped into one or multiple named groups, renamed inline, ordered vertically, kept persistently even when empty until explicitly deleted, and optionally displayed simultaneously as standalone buttons (*Show also as ungrouped*).
  * Rendered grouped views on the top toolbar inside titled framed boxes with a network/recorder icon, cyan highlight when any enclosed view is active, smooth animated expand/collapse transitions, and a compact standard-height collapsed group button showing the active inner view name underneath the group title.
  * Added a title-bar **Pin** button directly inside expanded groups synchronized bi-directionally with *Collapsed by default* (`collapsedByDefault`), and automatic collapse of unpinned/default-collapsed groups when clicking outside the group, leaving or collapsing the top bar, or opening another default-collapsed group.
  * Added inline **Line break** separators in the top-bar sequence editor: separators start a new visual row on the top bar when adjacent segments contain an expanded group, while collapsed groups stay inline on the same row in exact configured order.
* **Zero-Interruption Drag-and-Drop Reordering (`ReorderableViewRow`, `ViewportsLayoutModel`, `ViewportsLayoutCollectionModel`, `ViewportsLayout`):**
  * Added drag-and-drop reordering for views in Presets and for groups, group members, and top-bar items/separators in Layout Groups, keeping existing `QmlAVPlayer` streams alive cleanly (`holdActiveDuringMove`) and syncing group definitions, UUIDs, and ordering live across main and auxiliary windows.
* **Top Bar Transparency Slider & Settings / NVR Camera List UI Polish (`SideBar`, `NvrSettingsPanel`, `ViewGroupsPanel`, `NvrCamerasWindow`, `ConfirmDialog`, `CctvButton`):**
  * Added a configurable **Top bar background transparency (`0%–100%`, default `5%`)** slider in *Settings* synchronized live across main and auxiliary windows.
  * Added a **Save changes** action when editing existing NVR recorders to update settings without forcing camera re-discovery, unified corner radii across every Settings tab and the NVR Camera List window (`8 px` sections/cards/tiles/banners, `6 px` buttons/thumbnail generator/badges/chips/combos, `4 px` inputs/inner tags), and replaced the legacy header camera emoji in `NvrCamerasWindow` with the vector NVR recorder icon matching the top-bar NVR view button.
* **View Groups Documentation (`README.md`, `INSTRUCTIONS*.md`, `INSTRUKCJA.md`):**
  * Added detailed step-by-step documentation explaining group creation, assignment, top-bar expanding/collapsing, pinning, line separators, and drag-and-drop ordering.

## [2.7.8-3] - 2026-11-16

### Localization
* **Russian UI Localization (`kvision_ru_RU`, `Context`, `SideBar`, `translate_ts.py` — PR #10):**
  * Integrated the Russian Qt translation catalog contributed in PR #10 (`@demon-5656`), registered `translations/kvision_ru_RU.qm` in `kvision.qrc`, added the `{"ru", "kvision_ru_RU"}` language mapping in `src/context.cpp`, added `"Русский (ИИ)"` to the language selector in `src/SideBar.qml`, and added `kvision_ru_RU.ts` to `GOOGLE_LANG_MAP` in `tools/translate_ts.py`.
  * Translated all 30 missing post-PR UI and changelog keys (`LNG_00569`–`LNG_00598`, including `WAN/NAT` mode, port reachability tester, top bar auto-hide tuning, viewport merge/split, and settings persistence fix notes) into Russian and recompiled all `.qm` binaries.

## [2.7.8-2] - 2026-11-16

### Bug Fixes
* **Immediate Settings Persistence & Race Fix (`SideBar`, `RootWindow`, `AuxiliaryWindow`):**
  * Fixed a race condition between Qt Quick `Settings` (500 ms async flush timer) and `QFileSystemWatcher` / `RootWindow.onConfigFileChanged()` where changing `disableViewportZoomAnimation` ("Disable viewport zoom animation") or other settings checkboxes shortly before another config write (such as editing `topBarPersistenceMs`, toggling `lockGridSize`, closing Options, or exiting) could revert the option back to its previous value on disk.
  * Switched all persisted `SideBar` settings checkboxes (`View`, `Viewport`, and `General`) from `onCheckedChanged` to `onToggled` with immediate `Context.writeSetting()` disk writes and restored reactive `Qt.binding()` links so `CheckBox` states remain synced across imports and auxiliary windows.
  * Added immediate `Context.writeSetting()` persistence to `lockGridSwitch` in `RootWindow` and `AuxiliaryWindow`, grouped `disableViewportZoomAnimation` live-reload cleanly under View settings, preserved non-fullscreen window dimensions in `flushSettingsToDisk()`, and ensured both `quitConfirmDialog` and `Ctrl+Q` flush all settings before exiting.

## [2.7.8] - 2026-11-16

### Features, Improvements & Bug Fixes
* **Top Bar Grid Expander, Alignment & Auto-Hide Controls (`RootWindow`, `AuxiliaryWindow`, `PlaybackWindow`, `SideBar`):**
  * Replaced the grid unlock toggle switch with a compact `30x30` chevron expander button featuring dynamic lock/unlock tooltips (`"Unlock grid options"` / `"Lock grid options"`), placing the **More options** button in the first revealed row above a centered `3×3` grid size selector matrix (`1x1`–`9x9`) inside a 4-row downward dock protrusion.
  * Right-aligned multi-row view and recorder preset buttons in both the main window (`RootWindow`) and multi-monitor auxiliary windows (`AuxiliaryWindow`).
  * Added configurable **Top bar activation zone height (`px`)** (`topBarTriggerHeight`, default `12`, range `1–200`) and **Top bar persistence time (`ms`)** (`topBarPersistenceMs`, default `500`, range `0–10000`) settings in `SideBar` with live synchronization across Main, Auxiliary, and Playback windows.
* **Merged Viewport Preservation & Resize Crash Fix (`ViewportsLayoutModel`, `ViewportsLayout`):**
  * Added persistent `savedColumnSpan` and `savedRowSpan` properties to `ViewportsLayoutItem` so merged viewports are never destroyed when temporarily switching to smaller grids (e.g., `4x4 -> 3x3 -> 2x2 -> 1x1 -> 4x4`), including across configuration save/reload and legacy layout files.
  * Fixed a `nullptr` dereference segmentation fault in `ViewportsLayoutModel::data()` during `resize()` by allocating all `ViewportsLayoutItem` objects via `ensureItemsAllocated()` before emitting `beginInsertRows()` / `endInsertRows()`.
* **Right-Click Context Menu Merging & Splitting (`ViewportsLayout`, `SideBar`, `RootWindow`):**
  * Added ergonomic right-click context menu support for merging and splitting both occupied and empty grid tiles: one-click **Split viewports** on merged tiles, direct **Merge selected** on multi-cell selections, and a **Merge viewports** submenu (`2×2`–`8×8`) for single cells with live cyan cell highlighting on hover and automatic edge anchoring.
  * Added the **Enable merging and splitting viewports** (`enableMergeViewports`, default `true`) option in Settings synchronized across windows.
* **Localization & Release Pipeline (`tools/translate_ts.py`, `.github/workflows/`):**
  * Updated `tools/translate_ts.py` to auto-detect target QML `<context>` blocks from `src/`, added empty-result validation on translation fallback endpoints, and relocated keys `LNG_00585`–`LNG_00594` to their proper QML contexts across all 23 `.ts`/`.qm` files.
  * Unified tag-triggered GitHub Releases in `.github/workflows/release-tag.yml` (`deb`, `appimage`, `windows` feeding one `publish-release` job) so all platform packages are attached cleanly to version tags without race conditions.

## [2.7.7] - 2026-11-16

### Features, Improvements & Bug Fixes
* **Top Bar Rebuild, Dynamic Multi-line Views Wrapping & Auto-Hide Fix (`RootWindow`, `AuxiliaryWindow`, `EventFilter`):**
  * Rebuilt the top dock toolbar layout to dynamically wrap view and recorder buttons into multiple rows (`Flow` layout) based on available window width and button label lengths, completely eliminating button clipping/overflow when managing multiple NVRs or custom views.
  * Engineered a custom dock background using `QtQuick.Shapes` (`ShapePath`, `PathLine`, `PathArc`) with a clean vertical left step, uniform rounded corners on all bends, expanding downwards only under the views section while preserving standard single-row height (56px) for the left controls.
  * Added window-level pointer tracking via `EventFilter` (`target`, `MouseMove` / `Leave`) so hovering over any multi-row button keeps the auto-hide toolbar open until the cursor leaves the dock area.
  * Added dynamic wrapping, automatic height adjustment, and window-level pointer tracking in auxiliary multi-monitor windows (`AuxiliaryWindow`).
* **High-Contrast Vertical Scrollbars (`StyledScrollBar`, `SideBar`, `NvrStatusDialog`):**
  * Created a shared `StyledScrollBar` component with distinct track borders (`#2a3540` on `#0f151b`), prominent slate handles (`#5a6e7f`), persistent full opacity when scrolling is needed, and bright cyan hover/active highlights (`#33f7dc` / `#00f5d4`).
  * Added the vertical scrollbar to the recorder list in the NVR Status dialog (`NvrStatusDialog`) and fixed `ScrollView` scrollbar positioning and visibility across all seven settings tabs in the sidebar (`SideBar` - views, tools, recorders, general, performance, import/export, and changelog).

## [2.7.6-2] - 2026-11-13

### EN: Features, Improvements & Bug Fixes
* **TCP Port Reachability Verifier & "Remote Recorder (WAN / NAT)" Mode (`NvrSettingsPanel`, `HikvisionManager`, `Player`, `ViewportsLayout`):**
  * Added a **"Test Ports"** button in NVR Settings performing concurrent TCP reachability probes (`SDK`, `RTSP`, `HTTP`) with latency measurements and clear per-port diagnostic guidance explaining which ports are required for Live View vs SDK Login/Archive.
  * Added a per-recorder **"Remote recorder (WAN / NAT)"** option (`remoteRecorder` with a `WAN` indicator badge) that enforces `TCP` RTSP transport, extends FFmpeg probing and socket timeouts (`analyzeduration: 3s`, `probesize: 2MB`, `timeout/rw_timeout: 15s`, `demuxer_timeout: 20s`, without `nobuffer`), uses Sub-Stream (`02`) in multi-camera grids while seamlessly switching to Main Stream (`01`) when enlarged or in `1x1` view (unless Sub-Stream is manually forced), staggers multi-camera connection startup (`200 ms` steps), and applies exponential reconnect backoff (`3s` -> `6s` -> `12s` -> `15s`).
  * Added automatic RTSP port verification upon stream failure (`InvalidMedia`) to display an explicit `"RTSP port (554) unreachable"` message on the camera viewport instead of generic `"No media"`.
* **Remote / NAT Camera Discovery, Archive Search & FFmpeg Compatibility Fixes (Issue #9):**
  * Fixed SDK camera discovery fallback (`HikvisionManager::discoverCameras`) when the HTTP port (`80`) is closed behind NAT: properly discovers both analog/coax (`byChanNum` / `byAnalogChanEnable`) and IP (`NET_DVR_GET_IPPARACFG_V40`) channels on Hybrid DVRs and Pure NVRs, maps IP channels to valid RTSP channel IDs (`1..N` on NVRs, `byChanNum + 1..` on Hybrid DVRs instead of raw SDK `33+`), and fetches OSD channel names via `NET_DVR_GET_PICCFG_V40`/`V30`.
  * Fixed ISAPI XML channel ID collisions between `VideoInputChannel` and `InputProxyChannel` on Hybrid DVRs, replaced external `curl` invocations with native Qt networking (`QNetworkAccessManager` with HTTP->HTTPS redirect handling and fast TCP port pre-check), and added `HTTP 401` single-attempt abort protection against Hikvision's *Illegal Login Lock*.
  * Added automatic SDK `NET_DVR_FindFile_V40` fallback in `HikvisionISAPI` so Archive Timeline bars and Calendar recording indicators work over the SDK port (`8000`) even when the HTTP port (`80`) is not forwarded.
  * Fixed FFmpeg `< 5.0` vs `>= 5.0` (`LIBAVFORMAT_VERSION_MAJOR < 59`) RTSP `-timeout` / `-stimeout` option translation in `QmlAVOptions` (preventing passive `listen` mode failures on FFmpeg 4.x and ignored socket timeouts on FFmpeg 6/7+), preserved `InvalidMedia` status in `QmlAVPlayer` instead of overwriting it with `NoMedia` / 1-second reconnect loops, enabled asynchronous `NET_DVR_MakeKeyFrameSub` keyframe requests for sub-streams, and fixed automatic Sub-to-Main stream fallback for `hikvision://` channels.

### PL: Funkcje, Udoskonalenia i Poprawki Błędów
* **Weryfikator otwartości portów TCP oraz tryb „Zdalny rejestrator (WAN / NAT)” (`NvrSettingsPanel`, `HikvisionManager`, `Player`, `ViewportsLayout`):**
  * Dodano przycisk **„Sprawdź otwartość portów”** w panelu konfiguracji NVR wykonujący równoległy test połączenia TCP dla portów `SDK`, `RTSP` i `HTTP` wraz z pomiarem czasu odpowiedzi (`ms`) i czytelnym wskazaniem roli każdego portu.
  * Dodano przełącznik **„Zdalny rejestrator (WAN / NAT)”** (`remoteRecorder` z oznaczeniem `WAN` na liście rejestratorów), który automatycznie ustawia transport `TCP`, wydłuża bufory analizy i limity czasu FFmpeg (`analyzeduration: 3s`, `probesize: 2MB`, `timeout/rw_timeout: 15s`, `demuxer_timeout: 20s`, wyłączenie `nobuffer`), używa strumienia pomocniczego (`Sub`) w siatce wielokamerowej i płynnie przełącza na główny (`Main`) po powiększeniu kafelka lub w układzie `1x1` (chyba że `Sub` wymuszono ręcznie), kaskadowo otwiera kamery w siatce (co `200 ms`) oraz stosuje wykładniczy backoff ponawiania połączeń (`3s` -> `6s` -> `12s` -> `15s`).
  * Dodano automatyczną weryfikację portu RTSP przy błędzie strumienia i wyświetlanie precyzyjnego komunikatu **„Port RTSP (554) niedostępny”** bezpośrednio na kafelku kamery zamiast mylącego „Brak multimediów”.
* **Poprawki wykrywania kamer, osi czasu archiwum i zgodności FFmpeg dla połączeń zdalnych (Issue #9):**
  * Naprawiono zapasowe wykrywanie kamer przez SDK (`HikvisionManager::discoverCameras`) przy zamkniętym porcie HTTP (`80`) za NAT-em: poprawna obsługa zarówno kanałów analogowych BNC/coax (`byChanNum`), jak i kamer IP (`NET_DVR_GET_IPPARACFG_V40`) na rejestratorach hybrydowych i NVR, właściwe mapowanie numerów kanałów RTSP (`1..N` na NVR, `byChanNum + 1..` na hybrydach zamiast surowego `33+`) oraz odczyt nazw kamer OSD przez `NET_DVR_GET_PICCFG_V40`/`V30`.
  * Wyeliminowano kolizję identyfikatorów kanałów analogowych i IP w ISAPI XML na rejestratorach hybrydowych, zastąpiono wywołania zewnętrznego programu `curl` natywną obsługą sieci w Qt (`QNetworkAccessManager` z obsługą przekierowań HTTPS i szybkim testem TCP) oraz dodano zabezpieczenie przed blokadą konta na rejestratorze (*Illegal Login Lock*) przy błędzie `HTTP 401`.
  * Dodano automatyczny fallback wyszukiwania nagrań przez SDK (`NET_DVR_FindFile_V40`) w `HikvisionISAPI`, dzięki czemu paski nagrań na osi czasu oraz kropki w kalendarzu archiwum działają po samym porcie SDK (`8000`) nawet przy zamkniętym porcie HTTP (`80`).
  * Naprawiono translację opcji RTSP `-timeout` / `-stimeout` pomiędzy FFmpeg `< 5.0` i `>= 5.0` w `QmlAVOptions`, usunięto nadpisywanie błędu `InvalidMedia` statusem `NoMedia` i 1-sekundową pętlę reconnectów w `QmlAVPlayer`, dodano asynchroniczne wymuszanie klatek kluczowych dla podstrumieni (`NET_DVR_MakeKeyFrameSub`) oraz naprawiono automatyczne przełączanie awaryjne ze strumienia Sub na Main dla kanałów `hikvision://`.

## [2.7.5] - 2026-10-29

### EN: Features, Improvements & Bug Fixes
* **Windows System Statistics Panel (`SystemStats` / `StatsWorker`):**
  * Implemented native Win32 CPU and RAM usage monitoring in `StatsWorker::calculateCpuAndRam()` using `GetSystemTimes()`, `GetProcessTimes()`, and `K32GetProcessMemoryInfo()` (`WorkingSetSize`), fixing `0.0%` CPU and `0.0 MB` RAM readings on Windows.
  * Added Windows multi-process discovery in `StatsWorker::getProgramPids()` via `CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)` to aggregate CPU, RAM, GPU, VRAM, and Network metrics across all `kvision.exe` instances (`--auxiliary` multi-monitor windows) and child processes (`ffmpeg.exe`).
  * Added Windows GPU & VRAM monitoring via both NVIDIA `nvml.dll` (`C:\Windows\System32\nvml.dll`, including `_v2` symbol resolution and `NVML_VALUE_NOT_AVAILABLE` WDDM filtering) and universal Windows Performance Data Helper (`pdh.dll`) counters (`\GPU Engine(*)\Utilization Percentage` and `\GPU Process Memory(*)\Dedicated Usage` / `Local Usage`) supporting NVIDIA, AMD, and Intel GPUs.
  * Stabilized 1-second network speed (`Mbps`) and CPU delta sampling when opening the System Statistics panel by keeping background sampling aligned to the 1000ms timer and immediately publishing the latest cached sample via `StatsWorker::emitLatest()`.

### PL: Funkcje, Udoskonalenia i Poprawki Błędów
* **Panel statystyk systemu na Windowsie (`SystemStats` / `StatsWorker`):**
  * Dodano natywny pomiar zużycia procesora (CPU) oraz pamięci RAM w `StatsWorker::calculateCpuAndRam()` z użyciem funkcji Win32 API `GetSystemTimes()`, `GetProcessTimes()` oraz `K32GetProcessMemoryInfo()` (`WorkingSetSize`), eliminując problem stałego wyświetlania `0.0%` CPU i `0.0 MB` RAM na systemie Windows.
  * Dodano wykrywanie procesów na Windowsie w `StatsWorker::getProgramPids()` przy pomocy `CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)`, dzięki czemu statystyki CPU, RAM, GPU, VRAM oraz sieci sumują wszystkie okna `kvision.exe` (tryb wielomonitorowy `--auxiliary`) i procesy potomne (`ffmpeg.exe`).
  * Dodano odczyt obciążenia GPU i pamięci VRAM na Windowsie poprzez bibliotekę NVIDIA `nvml.dll` (`C:\Windows\System32\nvml.dll` z obsługą symboli `_v2` i filtrowaniem wartości `NVML_VALUE_NOT_AVAILABLE` na sterownikach WDDM) oraz uniwersalne liczniki systemowe Windows PDH (`pdh.dll`: `\GPU Engine(*)\Utilization Percentage` i `\GPU Process Memory(*)\Dedicated Usage` / `Local Usage`) działające na kartach NVIDIA, AMD oraz Intel.
  * Ustabilizowano 1-sekundowy takt pomiaru prędkości sieci (`Mbps`) oraz delty CPU przy otwieraniu panelu statystyk (`StatsWorker::emitLatest()`).

## [2.7.4] - 2026-10-29

### EN: Features, Improvements & Bug Fixes
* **Archive Video Download & Conversion Pipeline (`HikvisionDownloader`):**
  * Bundled `ffmpeg.exe` in the Windows x64 release package (`KVision-windows-x64.zip`) and added `resolveFfmpegExecutable()` so `HikvisionDownloader` automatically finds `ffmpeg.exe` next to `kvision.exe` without flashing a console window (`CREATE_NO_WINDOW`).
  * Implemented a 3-tier `.pspart` -> `.mp4` conversion pipeline: (1) `ffmpeg` CLI with video stream copy and AAC audio transcoding (`-c:v copy -c:a aac`), (2) automatic retry without audio (`-c:v copy -an`) when Hikvision PS audio streams are corrupted or unsupported, and (3) a built-in in-process `libavformat` remuxer fallback (`remuxPsToMp4InProcess`) that converts `.pspart` directly to `.mp4` without requiring an external process.
  * Fixed Windows NTFS directory entry caching during active `HCNetSDK.dll` downloads by reading uncached file sizes via file handle (`getActualFileSize()`), and added stall detection (`m_stalledTicks`) to cleanly finish SDK downloads and trigger MP4 conversion as soon as the stream ends instead of hitting an SDK timeout (`pos == 200`) and deleting `.pspart`.
  * Preserved `.pspart` files on disk if all conversion tiers ever fail so downloaded footage is never lost.
* **Windows Snapshot & Recording Folder Browsing (`SnapshotSavedDialog`, `Context`):**
  * Fixed the **"Browse"** (`Przeglądaj`) button in `SnapshotSavedDialog.qml` after taking a quick viewport snapshot by adding the missing `import CCTV_Viewer.Core 1.0` import.
  * Added `Context::openLocalFolder()` with automatic directory resolution and a native `explorer.exe` fallback on Windows across `SnapshotSavedDialog.qml`, `DownloadDialog.qml`, `PlaybackWindow.qml`, and `SideBar.qml`.
* **Windows Executable Icon & Resource Metadata (`kvision.rc`, `images/kvision.ico`):**
  * Embedded a multi-resolution (`256x256` down to `16x16`) application icon and Windows PE `VERSIONINFO` resource into `kvision.exe`.

### PL: Funkcje, Udoskonalenia i Poprawki Błędów
* **Pobieranie i konwersja nagrań z archiwum (`HikvisionDownloader`):**
  * Dołączono `ffmpeg.exe` do paczki wydania Windows x64 (`KVision-windows-x64.zip`) oraz dodano automatyczne wykrywanie `ffmpeg.exe` obok `kvision.exe` (z ukryciem okna konsoli `CREATE_NO_WINDOW`).
  * Wdrożono 3-poziomowy mechanizm konwersji `.pspart` -> `.mp4`: (1) `ffmpeg` CLI z kopiowaniem wideo i transkodowaniem dźwięku do AAC (`-c:v copy -c:a aac`), (2) automatyczne ponowienie bez ścieżki audio (`-c:v copy -an`) w przypadku uszkodzonego strumienia dźwięku z rejestratora, oraz (3) wbudowany remukser `libavformat` działający bezpośrednio w procesie aplikacji (`remuxPsToMp4InProcess`).
  * Naprawiono odczyt rzeczywistego rozmiaru pliku `.pspart` na systemie plików NTFS podczas pobierania przez `HCNetSDK.dll` oraz dodano detekcję zakończenia strumienia (`m_stalledTicks`), która natychmiast zamyka sesję pobierania i uruchamia konwersję do `.mp4` zamiast czekać na błąd timeout SDK (`pos == 200`) i usuwać plik `.pspart`.
  * Zabezpieczono plik `.pspart` przed usunięciem w razie niepowodzenia wszystkich metod konwersji.
* **Przeglądanie folderu stopklatek i nagrań na Windowsie (`SnapshotSavedDialog`, `Context`):**
  * Naprawiono niedziałający przycisk **„Przeglądaj”** po wykonaniu szybkiej stopklatki w viewporcie (`SnapshotSavedDialog.qml`) poprzez dodanie brakującego importu `import CCTV_Viewer.Core 1.0`.
  * Dodano metodę `Context::openLocalFolder()` z natywnym wsparciem `explorer.exe` na systemie Windows we wszystkich oknach programu (`SnapshotSavedDialog.qml`, `DownloadDialog.qml`, `PlaybackWindow.qml`, `SideBar.qml`).
* **Ikona programu Windows (`.exe`) i metadane wersji (`kvision.rc`, `images/kvision.ico`):**
  * Osadzono wielorozdzielczą (`256x256` – `16x16`) ikonę programu KVision oraz zasoby `VERSIONINFO` bezpośrednio w pliku wykonywalnym `kvision.exe`.

## [2.7.3] - 2026-10-28

### EN: Features, Improvements & Bug Fixes
* **Windows x64 Build Support & CI Workflow:** Integrated full Windows x64 compilation support (`MSVC 2022` / CMake / GitHub Actions CI, contributed by @kunxiang1 in PR #7) with automated artifact packaging (`windeployqt`, FFmpeg, Hikvision SDK, OpenSSL, and cURL DLLs) and multi-mirror HTTPS fallback for `aqtinstall`.
* **Cross-Platform Settings Import / Export:** Added a new **"Import / Export"** tab in the side panel allowing one-click export and import of the entire application configuration (`.conf` / `.ini`) between Linux and Windows, with automatic adaptation of snapshot and video recording paths to the target operating system and live hot-reload.
* **Windows Configuration File (`KVision.ini`) & Path Fixes:** Enforced `QSettings::IniFormat` on Windows so settings are stored in a standard file (`%APPDATA%\KVision\KVision.ini`) instead of the Windows Registry, and replaced fixed `.substring(7)` URL stripping with `QUrl::toLocalFile()` / `QUrl::fromLocalFile()` so Windows paths no longer start with a leading slash (`/C:/...`).
* **Unified Dark `Compact` Theme & `CheckBox` Visual Overhaul:** Fixed `CheckBox` controls on Windows where Qt's default light system palette caused black label text and oversized (`24x24`) white indicator boxes. Redesigned `Compact/CheckBox.qml` (`18x18` dark indicator, `#00f5d4` celadon accent border and vector SVG checkmark, crisp `#ffffff` label text) and configured a complete dark `[Compact\Palette]` in `qtquickcontrols2.conf` for consistent styling across Windows and Linux.

### PL: Funkcje, Udoskonalenia i Poprawki Błędów
* **Obsługa wersji Windows x64 i CI:** Wdrożono pełne wsparcie kompilacji dla systemu Windows x64 (`MSVC 2022` / CMake / GitHub Actions CI, współtworzone przez @kunxiang1 w PR #7) wraz z automatycznym pakowaniem bibliotek DLL oraz obsługą zapasowych serwerów lustrzanych HTTPS dla `aqtinstall`.
* **Wieloplatformowy Import / Eksport ustawień:** Dodano nową zakładkę **„Import / Eksport”** w panelu bocznym umożliwiającą eksport i import pełnej konfiguracji programu (`.conf` / `.ini`) pomiędzy systemami Linux i Windows wraz z automatycznym dopasowaniem ścieżek zapisu stopklatek i wideo do docelowego systemu oraz przeładowaniem na żywo.
* **Naprawa pliku konfiguracyjnego (`KVision.ini`) i ścieżek na Windowsie:** Wymuszono format `QSettings::IniFormat` na Windowsie (zapis w pliku `%APPDATA%\KVision\KVision.ini` zamiast w Rejestrze Windows) oraz wyeliminowano błędny początkowy ukośnik (`/C:/...`) w ścieżkach katalogów stopklatek i nagrań wideo poprzez użycie `QUrl::toLocalFile()` i `QUrl::fromLocalFile()`.
* **Poprawki wizualne ciemnego motywu `Compact` i pól wyboru (`CheckBox`):** Naprawiono wygląd pól wyboru (`CheckBox`) w wersji dla Windowsa, gdzie domyślna jasna paleta systemowa Qt powodowała czarny, nieczytelny tekst etykiet oraz nienaturalnie duże (`24x24`) białe kwadraty. Przeprojektowano `Compact/CheckBox.qml` (kompaktowy ciemny wskaźnik `18x18`, seledynowe obramowanie i wektorowy znacznik SVG `#00f5d4`, biały tekst `#ffffff`) oraz zdefiniowano pełną ciemną paletę `[Compact\Palette]` w `qtquickcontrols2.conf`.

## [2.7.2] - 2026-10-27

### EN: Features, Improvements & Bug Fixes
* **Chinese (`zh_CN`) Localization Overhaul:** Rewrote all active Simplified Chinese UI strings with proper, consistent video surveillance industry terminology (e.g., `摄像机`, `录像机/NVR`, `码流`, `主码流/子码流`, `窗格`, `回放`, `云台`) and fixed typographic conventions and format placeholders (contributed by @kunxiang1 in PR #6).
* **Ubuntu/Debian Automated Installer & Troubleshooting:** Added `tools/install_ubuntu.sh` for one-step dependency installation and compilation on Ubuntu/Debian derivatives, along with a comprehensive 5-point RTSP & QtMultimedia troubleshooting guide across all 22 localized instruction manuals.
* **Hardware Decoder Software Fallback:** Fixed an issue in `QmlAVVideoDecoder::initVideoDecoder` where a failed `av_hwdevice_ctx_create` call (e.g., unavailable GPU/VAAPI/CUDA context) aborted decoder initialization and caused a black viewport; it now gracefully falls back to CPU software decoding.
* **Hikvision Auto/Sub Stream Mode Fix:** Fixed `player.isSubStream` binding in `ViewportsLayout.qml` so `hikvision://` channels properly switch to sub-streams (`02` / `streamType: 1`) in Auto (multi-camera grid) and forced Sub modes even when `secondaryUrl` is empty.
* **Diagnostic Log Option Localization (`LNG_00549`):** Replaced the hardcoded Polish string for the diagnostic logs checkbox in `SideBar.qml` with translation key `LNG_00549` across all 22 supported languages.
* **Critical QML Load Error Logging:** Updated `customMessageHandler` in `main.cpp` to allow hard QML component errors (`is not a type`, `Cannot assign`, `is not defined`, `non-existent property`, `Unable to assign`) through to `stderr` even when diagnostic logging is disabled.
* **Explicit `AVDictionaryPtr` Deleter Type:** Replaced the generic lambda parameter `[](auto p)` with explicit `[](AVDictionary **p)` in `QmlAVOptions` (`qmlavoptions.h`) for stricter C++17 compiler compatibility.

### PL: Funkcje, Udoskonalenia i Poprawki Błędów
* **Przebudowa chińskiego tłumaczenia (`zh_CN`):** Przepisano wszystkie aktywne komunikaty interfejsu w języku chińskim uproszczonym z użyciem spójnej, profesjonalnej terminologii branży telewizji przemysłowej (CCTV) oraz poprawiono konwencje typograficzne i znaczniki formatowania (współtworzone przez @kunxiang1 w PR #6).
* **Automatyczny instalator Ubuntu/Debian i rozwiązywanie problemów:** Dodano skrypt `tools/install_ubuntu.sh` do jednoetapowej instalacji zależności i kompilacji na systemach z rodziny Ubuntu/Debian oraz rozbudowano 5-punktowy poradnik diagnostyki strumieni RTSP i wtyczek QtMultimedia we wszystkich 22 wersjach językowych instrukcji.
* **Awaryjne przełączanie dekodera sprzętowego na CPU:** Naprawiono błąd w `QmlAVVideoDecoder::initVideoDecoder`, w którym nieudana inicjalizacja urządzenia sprzętowego (`av_hwdevice_ctx_create`, np. przy braku dostępnego kontekstu VAAPI/CUDA/GPU) przerywała otwieranie dekodera i powodowała czarny ekran — teraz następuje płynne przełączenie na dekodowanie programowe (CPU).
* **Poprawa trybu Auto/Sub dla strumieni Hikvision:** Naprawiono wiązanie `player.isSubStream` w `ViewportsLayout.qml`, dzięki czemu kanały `hikvision://` poprawnie przełączają się na strumień pomocniczy (`02` / `streamType: 1`) w trybie Automatycznym (w siatce wielokamerowej) oraz wymuszonym Sub, nawet gdy pole `secondaryUrl` jest puste.
* **Lokalizacja opcji logów diagnostycznych (`LNG_00549`):** Zastąpiono zahardkodowany polski napis przy opcji pełnych logów diagnostycznych w `SideBar.qml` kluczem tłumaczenia `LNG_00549` we wszystkich 22 obsługiwanych językach.
* **Logowanie krytycznych błędów ładowania QML:** Zaktualizowano filtr `customMessageHandler` w `main.cpp`, aby przepuszczał twarde błędy kompilacji/ładowania komponentów QML (`is not a type`, `Cannot assign`, `is not defined`, `non-existent property`, `Unable to assign`) na `stderr` nawet przy wyłączonych pełnych logach diagnostycznych.
* **Jawne typowanie deletera `AVDictionaryPtr`:** Zastąpiono generyczny parametr lambdy `[](auto p)` jawnym typem `[](AVDictionary **p)` w `qmlavoptions.h` dla pełnej zgodności ze standardem C++17.

## [2.7.1-rc5] - 2026-08-27

### EN: Features & Bug Fixes
* **Custom Ports Live Streaming Fix:** Fixed an issue where custom HTTP/RTSP ports failed to stream video in Live View. Added dynamic reactivity in `Player.qml` to NVR settings changes, robust IP matching, and proper credential URL encoding.
* **ISAPI Discovery Architecture:** Overhauled camera channel discovery to query IP Proxy channels (`InputProxy/channels`), Analog channels (`Video/inputs/channels`), and Streaming channels (`Streaming/channels`) independently, ensuring pure IP NVRs, hybrid DVRs, and standalone IP cameras discover channels reliably.
* **Universal Authentication Negotiation:** Switched ISAPI communication to `--anyauth` in curl to automatically negotiate between Digest and Basic authentication.
* **FFmpeg Demuxer Credential Encoding:** Ensured percent-encoded credentials in RTSP URLs are preserved cleanly when loaded by QmlAV demuxer.
* **Mock Hikvision NVR Test Server:** Added `tools/mock_hikvision_server.py` supporting both ISAPI HTTP discovery and RTSP H.264 video streaming on custom ports for local development and verification.

### PL: Funkcje i Poprawki Błędów
* **Naprawa odtwarzania na niestandardowych portach:** Rozwiązano problem z brakiem obrazu na żywo przy konfiguracji niestandardowych portów HTTP/RTSP. Dodano dynamiczne odświeżanie widoków w `Player.qml` po zmianie ustawień rejestratora, ulepszono dopasowywanie adresów IP oraz dodano bezpieczne kodowanie poświadczeń w URL.
* **Usprawnienie wykrywania kanałów ISAPI:** Zreorganizowano proces wykrywania kanałów, aby niezależnie odpytywać kanały IP (`InputProxy/channels`), analogowe (`Video/inputs/channels`) oraz uniwersalne strumienie (`Streaming/channels`), gwarantując pełną zgodność z rejestratorami IP NVR, hybrydowymi DVR oraz kamerami IPC.
* **Automatyczna negocjacja autoryzacji:** Zastosowano opcję `--anyauth` w curl, co pozwala na automatyczny wybór pomiędzy Digest i Basic Authentication.
* **Kodowanie poświadczeń w demuxerze FFmpeg:** Zabezpieczono przekazywanie zakodowanych znaków w adresach RTSP bezpośrednio do demuxera QmlAV.
* **Symulator rejestratora do testów:** Dodano skrypt `tools/mock_hikvision_server.py` symulujący rejestrator Hikvision (ISAPI + RTSP H.264) na dowolnych portach do testów lokalnych.

## [2.7.1-rc4] - 2026-08-07

### EN: Features & Bug Fixes
* **URI Migration:** Added an automatic migration script at startup to clean up old saved `hikvision://` URIs in existing layouts, ensuring legacy saved layouts also benefit from the simplified and secure URI format (removing credentials and ports from the UI).

### PL: Funkcje i Poprawki Błędów
* **Migracja adresów URI:** Dodano automatyczny skrypt migracyjny przy starcie programu czyszczący stare zapisane adresy `hikvision://` w istniejących układach, dzięki czemu wcześniejsze układy również korzystają z uproszczonego i bezpieczniejszego formatu URI (usunięcie haseł i portów z interfejsu).

## [2.7.1-rc3] - 2026-08-07

### EN: Features & Bug Fixes
* **Simplified Internal URIs:** Removed credentials and port numbers from internal `hikvision://` URIs, cleaning up the configuration and improving internal URL generation logic.
* **Custom Ports Handling:** Fixed a bug where HTTP ISAPI searches would incorrectly fallback to port 80 or the SDK port instead of the configured HTTP port.

### PL: Funkcje i Poprawki Błędów
* **Uproszczenie wewnętrznych URI:** Usunięto dane logowania i numery portów z wewnętrznych adresów `hikvision://`, upraszczając konfigurację i poprawiając logikę generowania URL.
* **Obsługa niestandardowych portów:** Naprawiono błąd, przez który wyszukiwanie nagrań ISAPI HTTP niepoprawnie powracało do portu 80 lub portu SDK zamiast skonfigurowanego portu HTTP.

## [2.7.1-rc2] - 2026-08-07

### EN: Features & Diagnostics
* **Diagnostic Logs:** Introduced a new UI option to enable writing comprehensive diagnostic logs (including previously silenced FFmpeg and QML errors) to a dedicated `kvision_diagnostic.log` file in the application config directory. This assists in troubleshooting issues like memory leaks or silent decoding failures.

### PL: Funkcje i Diagnostyka
* **Logi diagnostyczne:** Wprowadzono nową opcję w interfejsie umożliwiającą zapis pełnych logów diagnostycznych (w tym wyciszonych wcześniej błędów FFmpeg i QML) do dedykowanego pliku `kvision_diagnostic.log` w katalogu konfiguracyjnym aplikacji. Pomaga to w diagnozowaniu problemów z wyciekami pamięci lub cichymi błędami dekodowania.

## [2.7.1-rc1] - 2026-08-04

### EN: Features & Bug Fixes
* **Per-NVR RTSP Transport:** Added a dedicated RTSP Transport setting (Auto/TCP/UDP) for each NVR recorder. This resolves recent connection issues over WAN/NAT by allowing users to force a specific protocol for Live View per device.
* **RTSP Transport UI Sync:** Fixed a visual bug in the viewport settings dialog and sidebar where the displayed `-rtsp_transport` FFmpeg option did not reflect the specific NVR override. The UI now accurately reads and displays the dynamically injected transport protocol.

### PL: Funkcje i Poprawki Błędów
* **Protokół RTSP per Rejestrator:** Dodano możliwość ręcznego wyboru protokołu RTSP (Auto/TCP/UDP) indywidualnie dla każdego rejestratora NVR. Rozwiązuje to ostatnie problemy z połączeniami przez WAN/NAT, umożliwiając wymuszenie protokołu dla wybranego urządzenia.
* **Synchronizacja interfejsu RTSP:** Naprawiono błąd wizualny w oknie ustawień viewportu i na pasku bocznym. Wyświetlane tam parametry FFmpeg (`-rtsp_transport`) poprawnie odzwierciedlają teraz nadpisany protokół (UDP lub TCP) przypisany do konkretnego rejestratora NVR.

## [2.7.0] - 2026-07-27

### EN: Features & Improvements
* **Hikvision Multi-Port Support:** Implemented independent port configuration for SDK, HTTP, and RTSP ports per NVR recorder, enabling seamless connection to recorders using non-standard or custom forwarded ports.
* **Settings UI/UX Enhancements:** Replaced implicit placeholder labels with permanent text headers above all port input fields in the NVR settings panel, ensuring context remains clear when fields are populated.
* **Multi-Language Support & Localization:** Updated all 22 supported languages with accurate localization strings for new port options.

### PL: Funkcje i Udoskonalenia
* **Obsługa wielu portów Hikvision:** Wdrożono niezależną konfigurację portów SDK, HTTP oraz RTSP dla każdego rejestratora NVR, co umożliwia prawidłowe połączenie z urządzeniami używającymi niestandardowych portów.
* **Udoskonalenia interfejsu ustawień NVR:** Zastąpiono znikające etykiety stałymi nagłówkami tekstowymi nad polami wprowadzania portów, co gwarantuje pełną czytelność po wpisaniu wartości.
* **Lokalizacja i wsparcie wielojęzyczne:** Zaktualizowano wszystkie 22 wspierane języki o przetłumaczone frazy dla opcji portów.

## [2.6.3] - 2026-07-08

### EN: Bug Fixes
* **Console Memory Reporting:** Enhanced the periodic memory reclaiming timer to log the exact amount of RAM (in MB) successfully returned to the operating system kernel via `malloc_trim(0)`. This message is always visible in standard console output without requiring `--verbose` mode.

### PL: Poprawki Błędów
* **Logowanie odzysku pamięci:** Ulepszono mechanizm okresowego zwalniania pamięci, dodając precyzyjną informację o dokładnej ilości pamięci RAM (w MB) pomyślnie zwróconej do jądra systemu za pomocą `malloc_trim(0)`. Komunikat ten jest zawsze widoczny na konsoli, również w trybie normalnym bez konieczności uruchamiania z flagą `--verbose`.

## [2.6.2] - 2026-07-08

### EN: Bug Fixes
* **Reduced Log Spam:** Suppressed repetitive QML/JS warnings, TypeErrors, and video packet decoding errors (e.g. "Unable send packet to decoder: Invalid data found...") from default output. These diagnostic logs are now only visible when running with `--verbose`.
* **Periodic Memory Reclaiming:** Added a background timer that runs once every hour to perform garbage collection and call `malloc_trim(0)`, releasing any unused heap memory back to the Linux kernel.

### PL: Poprawki Błędów
* **Ograniczenie hałasu w logach:** Wyciszono uciążliwe i powtarzające się błędy silnika QML (np. TypeError) oraz błędy dekodowania pakietów wideo ze standardowego wyjścia. Te komunikaty diagnostyczne są teraz wypisywane tylko przy uruchomieniu z parametrem `--verbose`.
* **Okresowe zwalnianie pamięci:** Dodano działający w tle zegar, który raz na godzinę wymusza odśmiecanie pamięci oraz wywołuje `malloc_trim(0)`, zwracając wszelkie nieużywane zasoby pamięci podręcznej sterty z powrotem do jądra systemu Linux.

## [2.6.1] - 2026-07-07

### EN: Bug Fixes
* **Fixed GPU Driver Memory Leak (NVIDIA/GLX):** Resolved a critical memory leak within the graphics driver stack (primarily affecting NVIDIA) by ensuring that the previous GLX texture image binding is explicitly released via `glXReleaseTexImageEXT` before drawing the next frame onto the X11 pixmap.
* **Thread Count Optimization:** Restricted FFmpeg decoding to a single thread per stream by default (setting `thread_count = 1` instead of `0` / auto-detect), preventing CPU thread explosion (e.g., 24 threads per camera on AMD Ryzen 9 24-core CPUs) and drastically reducing overall RAM usage and system context switching overhead.

### PL: Poprawki Błędów
* **Eliminacja wycieku pamięci w dekoderze (NVIDIA/GLX):** Naprawiono krytyczny wyciek pamięci na poziomie sterownika graficznego (szczególnie NVIDIA), powodowany brakiem zwalniania powiązania tekstury GLX (`glXReleaseTexImageEXT`) przed aktualizacją pixmapy X11 nową klatką wideo.
* **Ograniczenie liczby wątków dekodowania:** Ustawiono domyślną liczbę wątków dekodera FFmpeg na `1` dla każdego strumienia (zamiast `0` czyli auto-wykrywania), zapobiegając eksplozji wątków (np. 24 wątki na kamerę na 24-rdzeniowych procesorach AMD Ryzen 9) i drastycznie zmniejszając zużycie pamięci RAM oraz narzut przełączania kontekstu.

## [2.6.0] - 2026-07-03

### EN: New Features
* **Localization Expansion:** KVision is now fully localized into 20 new AI-translated languages, bringing the total number of supported languages to 22 (English, Polish, and 20 new languages). Both the entire application interface (UI) and the complete user manuals have been translated.
  * **Supported Languages:** Arabic (ar), Bulgarian (bg), Czech (cs), Danish (da), German (de), Greek (el), Spanish (es), Finnish (fi), French (fr), Hungarian (hu), Italian (it), Dutch (nl), Norwegian (no), Portuguese (pt), Romanian (ro), Slovak (sk), Swedish (sv), Turkish (tr), Ukrainian (uk), and Chinese (zh_CN).
* **Viewport Quick Playback documentation:** Added comprehensive documentation explaining the circular arrow overlay button (Miniplayer) and its detailed features in all 22 user manuals.

### PL: Nowe Funkcje
* **Rozszerzenie Lokalizacji:** KVision został w pełni przetłumaczony na 20 nowych języków wspomaganych przez AI, co daje łącznie 22 obsługiwane języki (angielski, polski oraz 20 nowych). Przetłumaczono zarówno cały interfejs aplikacji (UI), jak i pełne pliki instrukcji użytkownika.
  * **Obsługiwane języki:** arabski (ar), bułgarski (bg), czeski (cs), duński (da), niemiecki (de), grecki (el), hiszpański (es), fiński (fi), francuski (fr), węgierski (hu), włoski (it), holenderski (nl), norweski (no), portugalski (pt), rumuński (ro), słowacki (sk), szwedzki (sv), turecki (tr), ukraiński (uk) oraz chiński uproszczony (zh_CN).
* **Dokumentacja szybkiego podglądu:** Dodano szczegółowy opis nowej ikony szybkiego podglądu wstecz (Mini-odtwarzacza) oraz jej działania we wszystkich 22 plikach instrukcji użytkownika.

---

## [2.5.0] - 2026-07-03

### EN: New Features
* **Pan Zoom:** Added the ability to freely pan the zoomed-in video (Live, Mini-player, Archive) by holding down the middle mouse button (scroll wheel) and dragging the cursor.
* **Proportional Zoom Selection:** Introduced the `Shift` shortcut. Holding down the `Shift` key while drawing a zoom rectangle forces the selection to lock into a 16:9 aspect ratio, strictly constrained to the viewport boundaries.
* **Enforced Window Positioning:** Completely replaced the legacy window geometry saving mechanisms due to unresolvable multi-monitor projection issues in Qt. The application (both the main window and auxiliary windows) now strictly enforces launching centered on the primary monitor at 90% of its resolution, ensuring stability and predictability across all setups.
* **Localization Refactoring:** Replaced all hardcoded Polish and English strings embedded in the source code (`qsTr`, `tr`). Over 500 unique strings have been refactored into `LNG_XXXXX` identifiers, securely mapped via an improved `.ts`/`.qm` file system.
* **English-only CLI:** Command-line interface options and `--help` parameters are now permanently in English to prevent issues with delayed localization engine initialization.

### EN: Bug Fixes
* **Archive Aspect Ratio:** Fixed an issue where the aspect ratio of the video was distorted in the Archive player viewport. The `HikvisionArchivePlayer` component now correctly renders the original frame preserving its natural aspect ratio (letterboxing), instead of stretching the video to fit the UI boundaries.
* **Demuxer Memory Leaks:** Improved the object cleanup logic in the `QmlAVPlayer::stop()` routine, preventing "zombie" demuxer instances from accumulating in the background.
* **writeSetting Fix:** Added the missing implementation of the `writeSetting` method in the `Context` class, eliminating `TypeError`s and QML execution interruptions during settings migrations.

---

### PL: Nowe Funkcje
* **Przesuwanie powiększenia (Pan Zoom):** Dodano możliwość swobodnego przesuwania przybliżonego obrazu (Live, Mini-odtwarzacz, Archiwum) poprzez przytrzymanie wciśniętego środkowego przycisku myszy (kółka) i przesuwanie kursorem.
* **Proporcjonalne zaznaczanie powiększenia:** Wprowadzono skrót klawiszowy `Shift`. Trzymając wciśnięty klawisz `Shift` podczas rysowania prostokąta powiększenia (Lupka), zaznaczenie wymusza zablokowanie proporcji ekranu do 16:9, ograniczając ramkę do granic viewportu.
* **Wymuszone pozycjonowanie okien:** Zrezygnowano całkowicie z zapisywania geometrii okien po napotkaniu nieodwracalnych problemów Qt z poprawnym rzutowaniem na ekrany wielomonitorowe. Zamiast tego, aplikacja (zarówno okno główne, jak i okna pomocnicze) wymusza teraz otwieranie wyśrodkowane na głównym monitorze, w proporcjach 90% jego rozdzielczości, zapewniając stabilność i przewidywalność działania na każdym stanowisku.
* **Refaktoryzacja systemu tłumaczeń (Lokalizacja):** Zlikwidowano wszystkie sztywne polskie i angielskie teksty osadzone w kodzie źródłowym (`qsTr`, `tr`). Ponad 500 unikalnych ciągów zastąpiono jednolitymi identyfikatorami w formacie `LNG_XXXXX`, które są bezpiecznie mapowane przez ulepszony system plików `.ts`/`.qm`.
* **Wymuszony angielski w wierszu poleceń (CLI):** Opcje i parametry `--help` zostały zangielszczone na stałe, by uniknąć problemów z opóźnioną inicjalizacją mechanizmów lokalizacyjnych.

### PL: Poprawki
* **Zachowanie proporcji obrazu w Archiwum:** Naprawiono błąd zniekształcania proporcji obrazu w viewporcie odtwarzacza Archiwum. Komponent `HikvisionArchivePlayer` renderuje teraz oryginalną klatkę zachowując jej naturalny aspekt (dodając czarne paski), zamiast rozciągać wideo do wielkości okienka w interfejsie.
* **Wycieki pamięci Demuxerów:** Poprawiono logikę oczyszczania obiektów (cleanup) w procesie `QmlAVPlayer::stop()`, co zapobiega tworzeniu się "zombie" instancji demuxerów w tle.
* **Naprawa błędu writeSetting:** Dodano brakującą implementację metody `writeSetting` w klasie `Context`, co eliminuje błędy `TypeError` i przerywanie wykonywania kodu w QML przy migracjach ustawień.
