#!/usr/bin/env bash
# ==============================================================================
# KVision - Automated .rpm Package Builder (Fedora & RHEL / Rocky Linux 9+)
# ==============================================================================
set -euo pipefail

if [ ! -f "CMakeLists.txt" ] || [ ! -f "packaging/rpm/kvision.spec" ]; then
    echo "[-] Error: Run this script from the root of the KVision repository."
    exit 1
fi

export QT_QPA_PLATFORM=offscreen

DISTRO_LABEL="${1:-}"
OS_ID="linux"
OS_VER=""
if [ -r /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    OS_ID="${ID:-linux}"
    OS_VER="${VERSION_ID:-}"
fi
if [ -z "$DISTRO_LABEL" ]; then
    DISTRO_LABEL="${OS_ID}${OS_VER}"
fi

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

if [ "${SKIP_DNF_DEPS:-0}" != "1" ]; then
    echo "[*] Installing build dependencies for .rpm packaging (${DISTRO_LABEL})..."
    if [[ "$OS_ID" == "rhel" || "$OS_ID" == "rocky" || "$OS_ID" == "almalinux" || "$OS_ID" == "centos" ]]; then
        MAJOR_VER="${OS_VER%%.*}"
        $SUDO dnf install -y dnf-plugins-core epel-release
        $SUDO dnf config-manager --set-enabled crb || $SUDO dnf config-manager --set-enabled powertools || true
        $SUDO dnf install -y --nogpgcheck \
            "https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-${MAJOR_VER}.noarch.rpm"
        FFMPEG_DEV_PKG="ffmpeg-devel"
    else
        FFMPEG_DEV_PKG="ffmpeg-free-devel"
    fi

    $SUDO dnf install -y \
        rpm-build \
        cpio \
        gcc-c++ \
        cmake \
        pkgconf-pkg-config \
        git \
        tar \
        gzip \
        libva-devel \
        mesa-libGL-devel \
        libX11-devel \
        qt5-qtbase-devel \
        qt5-qtdeclarative-devel \
        qt5-qtmultimedia-devel \
        qt5-qtquickcontrols2-devel \
        qt5-qtsvg-devel \
        qt5-qttools-devel \
        gtest-devel \
        "$FFMPEG_DEV_PKG"
fi

RAW_VER="$(sed -n 's/^kvision (\([^)]*\)).*/\1/p' debian/changelog | head -n1)"
PKG_VERSION="${RAW_VER%%-*}"
PKG_VERSION="${PKG_VERSION:-2.7.12}"
RPM_ARCH="$(uname -m)"

RPM_TOPDIR="/tmp/kvision-rpmbuild"
rm -rf "$RPM_TOPDIR"
mkdir -p "$RPM_TOPDIR"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

SRC_DIR_NAME="kvision-${PKG_VERSION}"
echo "[*] Creating source tarball ${SRC_DIR_NAME}.tar.gz..."
tar --exclude='.git' --exclude='build*' --exclude='dist' \
    --transform="s,^\.,${SRC_DIR_NAME}," \
    -czf "${RPM_TOPDIR}/SOURCES/${SRC_DIR_NAME}.tar.gz" .

cp packaging/rpm/kvision.spec "${RPM_TOPDIR}/SPECS/kvision.spec"

echo "[*] Building .rpm package: kvision ${PKG_VERSION} (${DISTRO_LABEL}, ${RPM_ARCH})..."
export QA_RPATHS=$(( 0x0002 | 0x0004 ))
rpmbuild -bb "${RPM_TOPDIR}/SPECS/kvision.spec" \
    --define "_topdir ${RPM_TOPDIR}" \
    --define "pkg_version ${PKG_VERSION}" \
    --define "dist .${DISTRO_LABEL}" \
    --define "_smp_build_ncpus $(nproc)"

mkdir -p dist
BUILT_RPM="$(find "${RPM_TOPDIR}/RPMS" -name "kvision-*.rpm" ! -name '*-debuginfo-*' ! -name '*-debugsource-*' | head -n 1)"
if [ -z "$BUILT_RPM" ] || [ ! -f "$BUILT_RPM" ]; then
    echo "[-] Error: Built .rpm package not found in ${RPM_TOPDIR}/RPMS."
    exit 1
fi

OUT_RPM="dist/$(basename "$BUILT_RPM")"
mv -f "$BUILT_RPM" "$OUT_RPM"

echo "[*] Verifying RPM RPATH and Hikvision SDK shared libraries..."
VERIFY_DIR="${RPM_TOPDIR}/verify"
rm -rf "$VERIFY_DIR"
mkdir -p "$VERIFY_DIR"
rpm2cpio "$OUT_RPM" | (cd "$VERIFY_DIR" && cpio -idm --quiet)
RPATH_LINE="$(readelf -d "$VERIFY_DIR/usr/bin/kvision" | grep -E 'RPATH|RUNPATH' || true)"
echo "$RPATH_LINE"
if echo "$RPATH_LINE" | grep -q '\.\.//'; then
    echo "[-] Error: Invalid doubled slash in RPM RPATH: $RPATH_LINE"
    exit 1
fi
if [ -f "$VERIFY_DIR/usr/lib64/kvision/libhcnetsdk.so" ] && [ -f "$VERIFY_DIR/usr/lib64/kvision/libPlayCtrl.so" ]; then
    echo "$RPATH_LINE" | grep -F '[$ORIGIN/../lib64/kvision]'
elif [ -f "$VERIFY_DIR/usr/lib/kvision/libhcnetsdk.so" ] && [ -f "$VERIFY_DIR/usr/lib/kvision/libPlayCtrl.so" ]; then
    echo "$RPATH_LINE" | grep -F '[$ORIGIN/../lib/kvision]'
else
    echo "[-] Error: Hikvision SDK shared libraries not found in unpacked RPM under usr/lib*/kvision."
    exit 1
fi

echo "[+] Created package: $OUT_RPM ($(du -h "$OUT_RPM" | cut -f1))"
