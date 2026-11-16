#!/usr/bin/env bash
# ==============================================================================
# KVision - Portable x86_64 AppImage Builder (recommended base: Ubuntu 22.04)
# ==============================================================================
set -euo pipefail

if [ ! -f "CMakeLists.txt" ] || [ ! -d "src" ]; then
    echo "[-] Error: Run this script from the root of the KVision repository."
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive
export QT_QPA_PLATFORM=offscreen
export APPIMAGE_EXTRACT_AND_RUN=1

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    SUDO="sudo"
fi

if command -v git >/dev/null 2>&1; then
    git config --global --add safe.directory "$(pwd)" || true
    if [ -d ".git" ] && [ ! -f "src/qmlav/CMakeLists.txt" ]; then
        git submodule update --init --recursive
    fi
fi

if [ "${SKIP_APT_DEPS:-0}" != "1" ]; then
    echo "[*] Installing build, Qt5, QML, and FFmpeg dependencies for AppImage..."
    $SUDO apt-get update
    $SUDO apt-get install -y --no-install-recommends \
        cmake build-essential pkg-config git curl wget file patchelf desktop-file-utils \
        ca-certificates ffmpeg \
        qt5-qmake qtbase5-dev qtdeclarative5-dev qtmultimedia5-dev \
        qtquickcontrols2-5-dev libqt5svg5-dev libqt5multimedia5-plugins \
        qttools5-dev qttools5-dev-tools libgtest-dev \
        libva-dev libgl-dev libglx-dev libx11-dev \
        libavcodec-dev libavformat-dev libavutil-dev \
        libswscale-dev libswresample-dev libavdevice-dev \
        qml-module-qtgraphicaleffects \
        qml-module-qtquick2 \
        qml-module-qtquick-controls \
        qml-module-qtquick-controls2 \
        qml-module-qtquick-layouts \
        qml-module-qtquick-window2 \
        qml-module-qtquick-dialogs \
        qml-module-qtquick-shapes \
        qml-module-qtqml-models2 \
        qml-module-qtmultimedia \
        qml-module-qt-labs-platform \
        qml-module-qt-labs-settings \
        qml-module-qt-labs-folderlistmodel \
        qtwayland5
fi

VER_MAJ="$(sed -n 's/^set(VER_MAJ \([0-9]*\))/\1/p' CMakeLists.txt | head -n1)"
VER_MIN="$(sed -n 's/^set(VER_MIN \([0-9]*\))/\1/p' CMakeLists.txt | head -n1)"
VER_PAT="$(sed -n 's/^set(VER_PAT \([0-9]*\))/\1/p' CMakeLists.txt | head -n1)"
APP_VERSION="${VER_MAJ}.${VER_MIN}.${VER_PAT}"
ARCH="$(uname -m)"

BUILD_DIR="${BUILD_DIR:-build-appimage}"
APPDIR="$(pwd)/AppDir"
TOOLS_DIR="$(pwd)/appimage-tools"

rm -rf "$BUILD_DIR" "$APPDIR"
mkdir -p "$TOOLS_DIR" dist

echo "[*] Configuring and building KVision ${APP_VERSION}..."
cmake -B "$BUILD_DIR" -S . -DCMAKE_BUILD_TYPE=Release -DPACKAGER=APPIMAGE
cmake --build "$BUILD_DIR" -j"$(nproc)"
DESTDIR="$APPDIR" cmake --install "$BUILD_DIR"

# Bundle ffmpeg CLI alongside kvision binary so HikvisionDownloader resolves it locally
FFMPEG_BIN="$(command -v ffmpeg || true)"
if [ -n "$FFMPEG_BIN" ] && [ -f "$FFMPEG_BIN" ]; then
    cp -f "$FFMPEG_BIN" "$APPDIR/usr/bin/ffmpeg"
    chmod +x "$APPDIR/usr/bin/ffmpeg"
fi

# Download linuxdeploy & Qt plugin if not cached
LINUXDEPLOY="$TOOLS_DIR/linuxdeploy-${ARCH}.AppImage"
LINUXDEPLOY_QT="$TOOLS_DIR/linuxdeploy-plugin-qt-${ARCH}.AppImage"

if [ ! -x "$LINUXDEPLOY" ]; then
    echo "[*] Downloading linuxdeploy..."
    curl -fsSL -L -o "$LINUXDEPLOY" \
        "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-${ARCH}.AppImage"
    chmod +x "$LINUXDEPLOY"
fi

if [ ! -x "$LINUXDEPLOY_QT" ]; then
    echo "[*] Downloading linuxdeploy-plugin-qt..."
    curl -fsSL -L -o "$LINUXDEPLOY_QT" \
        "https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-${ARCH}.AppImage"
    chmod +x "$LINUXDEPLOY_QT"
fi

# Ensure linuxdeploy finds linuxdeploy-plugin-qt in PATH
export PATH="$TOOLS_DIR:$PATH"

# Resolve Qt5 qmake explicitly for multi-arch Debian/Ubuntu paths
if [ -z "${QMAKE:-}" ]; then
    if [ -x "/usr/lib/${ARCH}-linux-gnu/qt5/bin/qmake" ]; then
        export QMAKE="/usr/lib/${ARCH}-linux-gnu/qt5/bin/qmake"
    elif [ -x "/usr/lib/qt5/bin/qmake" ]; then
        export QMAKE="/usr/lib/qt5/bin/qmake"
    else
        export QMAKE="$(command -v qmake)"
    fi
fi

# Find Hikvision SDK directory inside AppDir (e.g. usr/lib/x86_64-linux-gnu/kvision)
HIK_SDK_APPDIR="$(find "$APPDIR/usr" -type d -name kvision -print -quit || true)"
if [ -n "$HIK_SDK_APPDIR" ]; then
    # Mirror SDK libs & HCNetSDKCom into usr/lib so bundled RPATH '$ORIGIN/../lib' works directly
    cp -a "$HIK_SDK_APPDIR/"* "$APPDIR/usr/lib/" 2>/dev/null || true
    export LD_LIBRARY_PATH="$APPDIR/usr/lib:$HIK_SDK_APPDIR:${LD_LIBRARY_PATH:-}"
fi

# Dynamically include only Qt5 plugins & directories present in this Qt installation
QT_PLUGIN_ROOT="$("$QMAKE" -query QT_INSTALL_PLUGINS)"
EXTRA_QT_PLUGINS_LIST=()
for plug in \
    mediaservice \
    audio \
    wayland-shell-integration \
    wayland-decoration-client \
    wayland-graphics-integration-client \
    platforms/libqwayland-egl.so \
    platforms/libqwayland-generic.so \
    platforms/libqoffscreen.so; do
    if [ -e "${QT_PLUGIN_ROOT}/${plug}" ]; then
        EXTRA_QT_PLUGINS_LIST+=("$plug")
    fi
done
if [ "${#EXTRA_QT_PLUGINS_LIST[@]}" -gt 0 ]; then
    export EXTRA_QT_PLUGINS
    EXTRA_QT_PLUGINS="$(IFS=';'; echo "${EXTRA_QT_PLUGINS_LIST[*]}")"
fi

export QML_SOURCES_PATHS="$(pwd)/src"
export VERSION="$APP_VERSION"
export OUTPUT="KVision-${APP_VERSION}-${ARCH}.AppImage"

DESKTOP_FILE="$APPDIR/usr/share/applications/kvision.desktop"
ICON_FILE="$APPDIR/usr/share/icons/hicolor/256x256/apps/kvision.png"

EXTRA_EXEC_ARGS=()
if [ -x "$APPDIR/usr/bin/ffmpeg" ]; then
    EXTRA_EXEC_ARGS+=("-e" "$APPDIR/usr/bin/ffmpeg")
fi

echo "[*] Bundling Qt5, QML modules, FFmpeg, and Hikvision SDK into AppImage..."
BUILT_APPIMAGE="$OUTPUT"
"$LINUXDEPLOY" \
    --appdir "$APPDIR" \
    -e "$APPDIR/usr/bin/kvision" \
    "${EXTRA_EXEC_ARGS[@]}" \
    -d "$DESKTOP_FILE" \
    -i "$ICON_FILE" \
    --plugin qt \
    --output appimage

if [ ! -f "$BUILT_APPIMAGE" ]; then
    BUILT_APPIMAGE="$(find . -maxdepth 1 -name '*.AppImage' ! -path './appimage-tools/*' | head -n 1)"
fi
if [ -z "$BUILT_APPIMAGE" ] || [ ! -f "$BUILT_APPIMAGE" ]; then
    echo "[-] Error: Built AppImage file not found."
    exit 1
fi

mv -f "$BUILT_APPIMAGE" "dist/${OUTPUT}"
echo "[+] Created AppImage: dist/${OUTPUT} ($(du -h "dist/${OUTPUT}" | cut -f1))"
