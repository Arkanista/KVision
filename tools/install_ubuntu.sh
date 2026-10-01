#!/usr/bin/env bash
# ==============================================================================
# KVision - Automated Build and Installation Script for Ubuntu / Debian
# ==============================================================================
set -euo pipefail

echo "======================================================================"
echo "          KVision - Installer for Ubuntu / Debian Derivatives         "
echo "======================================================================"

# Check if running in a Git repository
if [ ! -f "CMakeLists.txt" ] || [ ! -d "src" ]; then
    echo "[-] Error: Please run this script from the root of the KVision repository."
    exit 1
fi

# Request sudo upfront
echo "[*] Requesting administrator (sudo) privileges..."
sudo -v

# 1. Enable universe repository (required on Ubuntu 22.04 / 24.04 for Qt5 multimedia packages)
if command -v add-apt-repository >/dev/null 2>&1; then
    echo "[*] Enabling Ubuntu 'universe' repository..."
    sudo add-apt-repository -y universe || true
fi

# 2. Update package lists
echo "[*] Updating apt package lists..."
sudo apt update

# 3. Install required build and runtime dependencies
echo "[*] Installing build tools, Qt5, QML modules, and FFmpeg libraries..."
sudo apt install -y \
    cmake \
    build-essential \
    git \
    ffmpeg \
    qtdeclarative5-dev \
    qtmultimedia5-dev \
    qtquickcontrols2-5-dev \
    libqt5svg5-dev \
    libqt5multimedia5-plugins \
    qttools5-dev \
    libgtest-dev \
    libva-dev \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libswscale-dev \
    libavdevice-dev \
    qml-module-qtgraphicaleffects \
    qml-module-qtquick-controls2 \
    qml-module-qtquick-layouts \
    qml-module-qtmultimedia \
    qml-module-qt-labs-platform \
    qml-module-qt-labs-settings \
    qml-module-qt-labs-folderlistmodel \
    qml-module-qtquick-dialogs \
    qtwayland5

# 4. Synchronize git submodules
echo "[*] Checking and updating git submodules..."
git submodule update --init --recursive

# 5. Configure build directory with CMake
echo "[*] Configuring CMake build (Release, prefix /usr)..."
cmake -B build -S . \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr

# 6. Build the application
echo "[*] Compiling KVision..."
cmake --build build -j"$(nproc)"

# 7. Install the application and SDK libraries into the system
echo "[*] Installing KVision and Hikvision SDK to /usr..."
sudo cmake --install build
sudo ldconfig

echo ""
echo "======================================================================"
echo "[+] KVision has been successfully built and installed!"
echo "======================================================================"
echo ""
echo "To launch KVision, run:"
echo "    kvision"
echo ""
echo "[i] Important Tip for NVR Setup:"
echo "    When adding your Hikvision recorder in KVision Settings, set"
echo "    'RTSP Transport' to 'TCP' to ensure video streams bypass router/firewall"
echo "    UDP filtering."
echo "======================================================================"
