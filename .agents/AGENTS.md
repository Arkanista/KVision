# KVision Workspace Rules & Agent Guide

## Core Workspace Rules
* **GitHub Descriptions & Commits**: All GitHub release descriptions, tags, commit messages, and PRs must be in **English only**. Do not mix Polish and English in GitHub-facing descriptions.
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
