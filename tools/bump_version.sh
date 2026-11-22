#!/usr/bin/env bash
# ==============================================================================
# KVision - Automated Version Bumper (CMakeLists.txt, PKGBUILD, .spec, README)
# Usage: ./tools/bump_version.sh 2.7.15
# ==============================================================================
set -euo pipefail

if [ $# -ne 1 ] || [[ ! "$1" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    echo "Usage: $0 <MAJOR.MINOR.PATCH> (e.g. $0 2.7.15)"
    exit 1
fi

MAJ="${BASH_REMATCH[1]}"
MIN="${BASH_REMATCH[2]}"
PAT="${BASH_REMATCH[3]}"
NEW_VER="${MAJ}.${MIN}.${PAT}"

if [ ! -f "CMakeLists.txt" ]; then
    echo "[-] Error: Run this script from the root of the KVision repository."
    exit 1
fi

OLD_MAJ="$(sed -n 's/^set(VER_MAJ \([0-9]*\))/\1/p' CMakeLists.txt | head -n1)"
OLD_MIN="$(sed -n 's/^set(VER_MIN \([0-9]*\))/\1/p' CMakeLists.txt | head -n1)"
OLD_PAT="$(sed -n 's/^set(VER_PAT \([0-9]*\))/\1/p' CMakeLists.txt | head -n1)"
OLD_VER="${OLD_MAJ}.${OLD_MIN}.${OLD_PAT}"

echo "[*] Bumping version: ${OLD_VER} -> ${NEW_VER}"

sed -i "s/^set(VER_MAJ ${OLD_MAJ})/set(VER_MAJ ${MAJ})/" CMakeLists.txt
sed -i "s/^set(VER_MIN ${OLD_MIN})/set(VER_MIN ${MIN})/" CMakeLists.txt
sed -i "s/^set(VER_PAT ${OLD_PAT})/set(VER_PAT ${PAT})/" CMakeLists.txt

if [ -f "packaging/arch/PKGBUILD" ]; then
    sed -i "s/^pkgver=.*/pkgver=${NEW_VER}/" packaging/arch/PKGBUILD
fi

if [ -f "packaging/rpm/kvision.spec" ]; then
    sed -i "s/pkg_version:${OLD_VER}/pkg_version:${NEW_VER}/g" packaging/rpm/kvision.spec
fi

if [ -f "README.md" ]; then
    sed -i "s/${OLD_VER//./\\.}/${NEW_VER}/g" README.md
fi

echo "[+] Updated CMakeLists.txt, PKGBUILD, kvision.spec, and README.md to ${NEW_VER}."
echo "[*] Remember to add release notes to CHANGELOG.md, debian/changelog, packaging/arch/changelog, and src/SideBar.qml."
