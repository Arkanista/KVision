# Building KVision on Windows (x64)

This guide explains how to build and package **KVision** on 64-bit Windows using **MSVC 2022**, **Qt 5.15.2**, **FFmpeg**, and the **Hikvision Windows SDK (`EN-HCNetSDK`)**, either automatically via GitHub Actions or locally on a Windows machine.

---

## Option 1: Automated Build via GitHub Actions (Recommended)

The repository includes an automated CI workflow (`.github/workflows/build-windows.yml`) that compiles KVision and bundles all required runtime DLLs (Qt5, FFmpeg, OpenSSL, Hikvision SDK, and `HCNetSDKCom` plugins) into a portable `KVision-Windows-x64.zip` archive.

1. Go to the **Actions** tab in your GitHub repository.
2. Select **Build Windows x64** from the left sidebar.
3. Click **Run workflow** (or push to `master` / `main`).
4. Once the build completes, download the **`KVision-Windows-x64`** artifact, extract it anywhere on Windows, and run `kvision.exe`.

---

## Option 2: Local Build on Windows 10 / 11 (x64)

### 1. Prerequisites

1. **Visual Studio 2022** (Community, Professional, or Enterprise) with the **Desktop development with C++** workload (MSVC v143 x64 toolset).
2. **Qt 5.15.2 (`msvc2019_64`)**:
   - Install via the Qt Online Installer or [`aqtinstall`](https://github.com/miurahr/aqtinstall):
     ```powershell
     pip install aqtinstall
     aqt install-qt windows desktop 5.15.2 win64_msvc2019_64 -O C:\Qt
     ```
3. **CMake** (>= 3.14) and **Ninja** (or Visual Studio generator).
4. **FFmpeg (Windows x64 Shared Dev Build)**:
   - Download `ffmpeg-master-latest-win64-gpl-shared.zip` from [BtbN/FFmpeg-Builds](https://github.com/BtbN/FFmpeg-Builds/releases).
   - Extract it (e.g. to `C:\ffmpeg`) so that `C:\ffmpeg\include`, `C:\ffmpeg\lib`, and `C:\ffmpeg\bin` exist.
5. **Hikvision Windows x64 SDK (`EN-HCNetSDKV6.1.9.48_build20230410_win64`)**:
   - Copy the Windows `.lib` files (`HCNetSDK.lib`, `PlayCtrl.lib`, `HCCore.lib`, `GdiPlus.lib`) into `src/hikvision_sdk/lib/win64/`.
   - Keep the runtime `.dll` files (`HCNetSDK.dll`, `PlayCtrl.dll`, `HCCore.dll`, `SuperRender.dll`, `AudioRender.dll`, `HCNetSDKCom\`, etc.) ready to deploy next to `kvision.exe`.

---

### 2. Configure & Compile via Command Line

Open the **x64 Native Tools Command Prompt for VS 2022** and run:

```cmd
cmake -B build -G Ninja ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_PREFIX_PATH="C:/Qt/5.15.2/msvc2019_64" ^
  -DFFMPEG_DIR="C:/ffmpeg"

cmake --build build --config Release
```

*(Alternatively, you can use `-G "Visual Studio 17 2022" -A x64` and `cmake --build build --config Release`).*

---

### 3. Deploying Runtime Libraries (`windeployqt`)

To create a standalone portable folder (e.g., `dist\KVision`):

1. Copy `build\kvision.exe` and `build\ffmpeg.exe` (or `C:\ffmpeg\bin\ffmpeg.exe`) into `dist\KVision\`.
2. Run `windeployqt` to bundle Qt5 DLLs and QML modules:
   ```cmd
   C:\Qt\5.15.2\msvc2019_64\bin\windeployqt.exe --release --qmldir src dist\KVision\kvision.exe
   ```
3. Copy all FFmpeg `.dll` files from `C:\ffmpeg\bin\*.dll` into `dist\KVision\`.
4. Copy all Hikvision Windows SDK `.dll` files (`HCNetSDK.dll`, `HCCore.dll`, `PlayCtrl.dll`, `SuperRender.dll`, `AudioRender.dll`, `hlog.dll`, `hpr.dll`, `libcrypto-1_1-x64.dll`, `libssl-1_1-x64.dll`, `zlib1.dll`, and the `HCNetSDKCom` subfolder) into `dist\KVision\`.

---

## Configuration File Location & Cross-Platform Import / Export (Linux ↔ Windows)

On both Linux and Windows, KVision stores its configuration in standard **INI format** (`QSettings::IniFormat`):

- **Windows:** `%APPDATA%\KVision\KVision.ini` (i.e., `C:\Users\<Username>\AppData\Roaming\KVision\KVision.ini`)
- **Linux:** `~/.config/KVision/KVision.conf`

### Built-in Import / Export Tab
You can transfer your entire setup (recorders, custom camera names, grid layouts, and preferences) between Linux and Windows directly from the KVision interface:
1. Open the side panel (**Menu**).
2. Select the **Import / Export** tab (located between **Settings** and **Changelog**).
3. Click **Export settings to file...** on the source system or **Import settings from file...** on the target system.
4. Platform-specific paths (such as default snapshot and video recording folders) are automatically sanitized and adapted to the target operating system upon import.
