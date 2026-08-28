# KVision Workspace Rules & Agent Guide

## Core Workspace Rules
* **GitHub Descriptions & Commits**: All GitHub release descriptions, tags, commit messages, and PRs must be in **English only**. Do not mix Polish and English in GitHub-facing descriptions.
* **Code Style & Structure**: Follow modern Qt/C++ (C++17) idioms. Keep QML code declarative and separate business logic into C++ classes where appropriate.

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
