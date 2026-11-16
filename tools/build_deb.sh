#!/usr/bin/env bash
# ==============================================================================
# KVision - Automated .deb Package Builder (Debian 12/13 & Ubuntu 22.04+)
# ==============================================================================
set -euo pipefail

if [ ! -f "CMakeLists.txt" ] || [ ! -f "debian/control" ]; then
    echo "[-] Error: Run this script from the root of the KVision repository."
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive
export QT_QPA_PLATFORM=offscreen

DISTRO_LABEL="${1:-}"
if [ -z "$DISTRO_LABEL" ] && [ -r /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    DISTRO_LABEL="${ID:-linux}${VERSION_ID:-}"
fi
DISTRO_LABEL="${DISTRO_LABEL:-linux}"

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
    echo "[*] Updating apt repositories..."
    $SUDO apt-get update

    # Ensure Ubuntu 'universe' is enabled (handles both legacy sources.list and DEB822 ubuntu.sources)
    if [ -r /etc/os-release ] && grep -qi '^ID=ubuntu' /etc/os-release; then
        if ! apt-cache show qtquickcontrols2-5-dev >/dev/null 2>&1; then
            echo "[*] Enabling Ubuntu 'universe' component..."
            if [ -f /etc/apt/sources.list.d/ubuntu.sources ]; then
                sed -i 's/^Components: main$/Components: main universe/' /etc/apt/sources.list.d/ubuntu.sources || true
                sed -i 's/^Components: main restricted$/Components: main restricted universe/' /etc/apt/sources.list.d/ubuntu.sources || true
            fi
            if [ -f /etc/apt/sources.list ]; then
                sed -i '/universe/!s/^\(deb .* main.*\)$/\1 universe/' /etc/apt/sources.list || true
            fi
            $SUDO apt-get update
        fi
    fi

    echo "[*] Installing build dependencies for .deb packaging..."
    $SUDO apt-get install -y --no-install-recommends \
        dpkg-dev debhelper devscripts fakeroot build-essential ca-certificates git
    $SUDO apt-get build-dep -y .
fi

PKG_VERSION="$(dpkg-parsechangelog -S Version)"
DEB_ARCH="$(dpkg-architecture -qDEB_HOST_ARCH)"

echo "[*] Building .deb package: kvision ${PKG_VERSION} (${DISTRO_LABEL}, ${DEB_ARCH})..."
rm -f ../kvision_*_"${DEB_ARCH}".deb ../kvision-dbgsym_*_"${DEB_ARCH}".* || true
dpkg-buildpackage -us -uc -b -j"$(nproc)"

mkdir -p dist
BUILT_DEB="../kvision_${PKG_VERSION}_${DEB_ARCH}.deb"
if [ ! -f "$BUILT_DEB" ]; then
    BUILT_DEB="$(find .. -maxdepth 1 -name "kvision_*_${DEB_ARCH}.deb" ! -name '*-dbgsym_*' | head -n 1)"
fi
if [ -z "$BUILT_DEB" ] || [ ! -f "$BUILT_DEB" ]; then
    echo "[-] Error: Built .deb package not found in parent directory."
    exit 1
fi

OUT_DEB="dist/kvision_${PKG_VERSION}_${DISTRO_LABEL}_${DEB_ARCH}.deb"
mv -f "$BUILT_DEB" "$OUT_DEB"
echo "[+] Created package: $OUT_DEB ($(du -h "$OUT_DEB" | cut -f1))"
