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

mkdir -p dist
OUT_FLATPAK="dist/KVision-${PKG_VERSION}-${ARCH}.flatpak"
echo "[*] Exporting single-file Flatpak bundle: ${OUT_FLATPAK}..."
flatpak build-bundle "$REPO_DIR" "$OUT_FLATPAK" io.github.arkanista.KVision

echo "[+] Created package: $OUT_FLATPAK ($(du -h "$OUT_FLATPAK" | cut -f1))"
