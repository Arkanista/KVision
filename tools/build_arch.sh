#!/usr/bin/env bash
# ==============================================================================
# KVision - Automated Arch Linux (.pkg.tar.zst) Package Builder
# ==============================================================================
set -euo pipefail

if [ ! -f "CMakeLists.txt" ] || [ ! -f "packaging/arch/PKGBUILD" ]; then
    echo "[-] Error: Run this script from the root of the KVision repository."
    exit 1
fi

export QT_QPA_PLATFORM=offscreen
export CMAKE_BUILD_PARALLEL_LEVEL="${CMAKE_BUILD_PARALLEL_LEVEL:-$(nproc)}"

REPO_ROOT="$(pwd)"
ARCH_DIR="${REPO_ROOT}/packaging/arch"

if command -v git >/dev/null 2>&1; then
    git config --global --add safe.directory "$REPO_ROOT" || true
    git config --global --add safe.directory "$REPO_ROOT/src/qmlav" || true
    if [ -d ".git" ] && [ ! -f "src/qmlav/CMakeLists.txt" ]; then
        git submodule update --init --recursive
    fi
fi

if [ "$(id -u)" -eq 0 ] && [ "${SKIP_PACMAN_DEPS:-0}" != "1" ]; then
    echo "[*] Updating Arch Linux package databases and installing dependencies..."
    if [ ! -d "/etc/pacman.d/gnupg" ]; then
        pacman-key --init
        pacman-key --populate archlinux
    fi
    pacman -Syu --noconfirm --needed \
        base-devel git cmake gtest \
        qt5-tools qt5-declarative qt5-multimedia \
        qt5-quickcontrols qt5-quickcontrols2 qt5-svg qt5-graphicaleffects \
        ffmpeg libva libx11 libglvnd
fi

BUILD_TMP="$(mktemp -d /tmp/kvision-arch-XXXXXX)"
cleanup() {
    if [ -n "$BUILD_TMP" ] && [ -d "$BUILD_TMP" ]; then
        rm -rf "$BUILD_TMP"
    fi
}
trap cleanup EXIT

PKG_OUT="${BUILD_TMP}/pkgdest"
MAKEPKG_BUILD="${BUILD_TMP}/builddir"
MAKEPKG_SRC="${BUILD_TMP}/srcdest"
MAKEPKG_LOG="${BUILD_TMP}/logdest"
mkdir -p "$PKG_OUT" "$MAKEPKG_BUILD" "$MAKEPKG_SRC" "$MAKEPKG_LOG"
mkdir -p dist

if [ "$(id -u)" -eq 0 ]; then
    if ! id -u builder >/dev/null 2>&1; then
        useradd -m -s /bin/bash builder
    fi
    git config --system --add safe.directory '*' || true
    chown -R builder:builder "$BUILD_TMP"

    echo "[*] Running makepkg as unprivileged 'builder' user..."
    su -s /bin/bash builder -c "
        set -euo pipefail
        cd '$ARCH_DIR'
        export BUILDDIR='$MAKEPKG_BUILD'
        export SRCDEST='$MAKEPKG_SRC'
        export PKGDEST='$PKG_OUT'
        export LOGDEST='$MAKEPKG_LOG'
        export QT_QPA_PLATFORM=offscreen
        export CMAKE_BUILD_PARALLEL_LEVEL='$CMAKE_BUILD_PARALLEL_LEVEL'
        makepkg -f --noconfirm
    "
else
    echo "[*] Building Arch Linux package as $(whoami)..."
    (
        cd "$ARCH_DIR"
        export BUILDDIR="$MAKEPKG_BUILD"
        export SRCDEST="$MAKEPKG_SRC"
        export PKGDEST="$PKG_OUT"
        export LOGDEST="$MAKEPKG_LOG"
        if [ "${SKIP_PACMAN_DEPS:-0}" = "1" ]; then
            makepkg -f --noconfirm
        else
            makepkg -fs --noconfirm
        fi
    )
fi

BUILT_PKG="$(find "$PKG_OUT" -maxdepth 1 -name 'kvision-*.pkg.tar.zst' ! -name 'kvision-debug-*' | head -n 1)"
if [ -z "$BUILT_PKG" ] || [ ! -f "$BUILT_PKG" ]; then
    echo "[-] Error: Built .pkg.tar.zst package not found in $PKG_OUT."
    exit 1
fi

OUT_PKG="dist/$(basename "$BUILT_PKG")"
cp -f "$BUILT_PKG" "$OUT_PKG"
echo "[+] Created package: $OUT_PKG ($(du -h "$OUT_PKG" | cut -f1))"
