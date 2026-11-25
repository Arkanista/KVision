#!/usr/bin/env bash
# ==============================================================================
# KVision - Automated Flatpak Bundle Builder (x86_64)
# ==============================================================================
set -euo pipefail

if [ ! -f "CMakeLists.txt" ] || [ ! -f "packaging/flatpak/io.github.arkanista.KVision.yml" ]; then
    echo "[-] Error: Run this script from the root of the KVision repository."
    exit 1
fi

RAW_VER="$(sed -n 's/^kvision (\([^)]*\)).*/\1/p' debian/changelog | head -n1)"
PKG_VERSION="${RAW_VER%%-*}"
PKG_VERSION="${PKG_VERSION:-2.7.12}"
ARCH="$(uname -m)"

BUILD_DIR="/tmp/kvision-flatpak-build"
REPO_DIR="/tmp/kvision-flatpak-repo"
rm -rf "$BUILD_DIR" "$REPO_DIR"

echo "[*] Building Flatpak for io.github.arkanista.KVision (${PKG_VERSION}, ${ARCH})..."
flatpak-builder --user --force-clean --repo="$REPO_DIR" "$BUILD_DIR" \
    packaging/flatpak/io.github.arkanista.KVision.yml

echo "[*] Verifying Flatpak RPATH, Hikvision SDK, and bundled FFmpeg 9.1..."
readelf -d "$BUILD_DIR/files/bin/kvision" | grep -F '[$ORIGIN/../lib/kvision]'
test -f "$BUILD_DIR/files/lib/kvision/libhcnetsdk.so"
test -f "$BUILD_DIR/files/lib/kvision/libPlayCtrl.so"
LDD_OUT="$(flatpak-builder --run "$BUILD_DIR" packaging/flatpak/io.github.arkanista.KVision.yml ldd /app/bin/kvision)"
echo "$LDD_OUT" | grep -E "libhcnetsdk\.so|libPlayCtrl\.so|libavformat\.so|libavcodec\.so"
if echo "$LDD_OUT" | grep -q "not found"; then
    echo "[-] Error: Unresolved shared libraries in Flatpak binary:"
    echo "$LDD_OUT" | grep "not found"
    exit 1
fi
echo "$LDD_OUT" | grep -Eq "libhcnetsdk\.so => (/app/bin/\.\./|/app/)lib/kvision/libhcnetsdk\.so"
echo "$LDD_OUT" | grep -Eq "libPlayCtrl\.so => (/app/bin/\.\./|/app/)lib/kvision/libPlayCtrl\.so"
echo "$LDD_OUT" | grep -Eq "libavformat\.so\.63 => /app/lib/libavformat\.so\.63"
echo "$LDD_OUT" | grep -Eq "libavcodec\.so\.63 => /app/lib/libavcodec\.so\.63"
flatpak-builder --run "$BUILD_DIR" packaging/flatpak/io.github.arkanista.KVision.yml /app/bin/ffmpeg -hide_banner -decoders | grep -Eq '\bhevc\b'
strings "$BUILD_DIR/files/lib/libavformat.so.63" | grep -q "SHA-256-sess"

mkdir -p dist
OUT_FLATPAK="dist/KVision-${PKG_VERSION}-${ARCH}.flatpak"
echo "[*] Exporting single-file Flatpak bundle: ${OUT_FLATPAK}..."
flatpak build-bundle "$REPO_DIR" "$OUT_FLATPAK" io.github.arkanista.KVision

echo "[+] Created package: $OUT_FLATPAK ($(du -h "$OUT_FLATPAK" | cut -f1))"
