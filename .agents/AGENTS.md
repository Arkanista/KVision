# KVision Workspace Rules & Agent Guide

## Core Workspace Rules
* **GitHub Descriptions, Changelogs & Commits**: All GitHub release descriptions, tags, commit messages, PRs, and changelog files (`CHANGELOG.md`, `packaging/arch/changelog`, `debian/changelog`) must be in **English only**. Do not mix Polish and English in GitHub-facing or changelog descriptions.
* **GitHub Release Packages Rule**: Whenever publishing a version tag/release (`vX.Y.Z`), **always** wait for CI builds to succeed and attach & link **all** compiled packages directly in that version's GitHub Release (Arch Linux `.pkg.tar.zst`, Windows `KVision-windows-x64.zip`, portable `KVision-X.Y.Z-x86_64.AppImage`, and all `.deb` packages for Debian 12/13 and Ubuntu 22.04–latest).
* **Localization & Translations (`LNG_XXXXX` / `.ts`) — Token-Saving Rule**: **NEVER** translate UI strings or in-app changelog entries into the 20+ target languages manually inside your LLM context/response. Always use Google Translate API via the reusable script [`tools/translate_ts.py`](file:///home/robert/cctv/kvision/tools/translate_ts.py) (e.g., `python3 tools/translate_ts.py --id LNG_XXXXX --en "..." --pl "..." --compile` or `--json ... --compile`) to populate all 23 `.ts` language files and compile `.qm` binaries.
* **CI Monitoring — Token-Saving Rule**: **NEVER** stream raw `gh run watch` tables into tool output (polling every 3s dumps tens of KB of redundant logs). Whenever waiting for a CI run (e.g., before finalizing a tag release or when verifying a CI fix), always silence the watch output and print only a compact per-job summary at the end: `gh run watch <id> -R Arkanista/KVision --exit-status >/dev/null 2>&1; gh run view <id> -R Arkanista/KVision --json jobs --jq '.jobs[] | "\(.name): \(.conclusion)"'`. Do not auto-watch CI on every push unless verifying CI changes or preparing a release tag.
* **Code Style & Structure**: Follow modern Qt/C++ (C++17) idioms. Keep QML code declarative and separate business logic into C++ classes where appropriate.
* **Mandatory Windows Build & Cross-Platform Verification (`MSVC` / `_WIN32`)**: Every C++, QML, and CMake change **MUST** be verified to ensure it does not break the Windows x64 (`MSVC 2022`) compiler or Windows runtime behavior:
  * **Platform-Specific Headers & APIs**: Never include Linux/POSIX-only headers (e.g., `<unistd.h>`, `<malloc.h>`, `<sys/resource.h>`, `<sys/utsname.h>`) or call Linux-specific functions (`malloc_trim`, `/proc/*` reads) without guarding them inside `#ifndef _WIN32 ... #endif` (or `#ifdef _WIN32 ... #else ... #endif`).
  * **MSVC Compiler Compatibility**: Avoid GCC/Clang-only extensions (such as VLAs, statement expressions, or unguarded `__attribute__`). Ensure all standard integer/string types and lambdas conform to strict MSVC C++17 rules.
  * **Cross-Platform Paths & `QSettings`**: Always use `QSettings::IniFormat` on both Linux and Windows. Never strip `"file://"` using fixed string offsets like `.substring(7)` (which leaves a leading `/` before drive letters like `/C:/...` on Windows) or concatenate `"file://" + path` directly; always use `Context.urlToLocalFile()`, `Context.pathToUrl()`, and `Context.sanitizePlatformPath()`.
  * **CMake Changes**: Any changes to `CMakeLists.txt` or `src/qmlav/CMakeLists.txt` must preserve the `if(WIN32)` / `else()` branches and Windows SDK/FFmpeg linking rules.

---

## AI Agent Knowledge Base Index

To understand the architecture and locate relevant files quickly, refer to the following documentation in the `.agents/` directory:

1. [**Architecture Overview**](file:///home/robert/cctv/kvision/.agents/ARCHITECTURE.md)
   * High-level system overview (C++ Core + Qt/QML UI).
   * Process model: Main process vs Auxiliary multi-monitor processes (`--auxiliary`).
   * Multimedia architecture: `QmlAV` (FFmpeg-based) and `Hikvision SDK / ISAPI`.
   * Configuration, state management, and multi-process hot-reloading (`QSettings` / `QFileSystemWatcher`).
   * Memory management and background cleanup (`trimMemory()`).

2. [**Codebase Map & API Reference**](file:///home/robert/cctv/kvision/.agents/CODEBASE_MAP.md)
   * Detailed breakdown of all C++ classes, QML components, and project directories.
   * File-by-file responsibilities and key methods/properties.

3. [**Data Flows & Lifecycles**](file:///home/robert/cctv/kvision/.agents/DATA_FLOWS.md)
   * Live streaming pipeline (RTSP / SDK / FFmpeg).
   * Archive search, playback, and timeline synchronization.
   * Video export / download pipeline (ISAPI / SDK -> FFmpeg MP4 remuxing).
   * NVR status & health monitoring background loop.
   * Multi-window configuration sync.

4. [**Configuration Schema & Dictionary**](file:///home/robert/cctv/kvision/.agents/CONFIG_SCHEMA.md)
   * Exhaustive dictionary of all `QSettings` keys, sections, types, and defaults.
   * JSON schemas for dynamic configurations (`recordersJson`, `models`).

5. [**Development Guide & SDK Gotchas**](file:///home/robert/cctv/kvision/.agents/DEVELOPMENT_GUIDE.md)
   * Domain rules: Hikvision NVR logical vs physical channel calculation (`byStartDChan`).
   * Thread safety and callback guidelines for `libhcnetsdk.so`.
   * Audio PCM format adaptation and memory management (`malloc_trim`).
   * Build, run, and diagnostic commands cheat-sheet.
