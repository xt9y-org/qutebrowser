#!/usr/bin/env bash

set -euo pipefail

# Build helper for a qutebrowser QtWebEngine with WebGPU/Dawn enabled.
#
# QtWebEngine is a Qt module around Chromium. A working WebGPU implementation
# requires the Chromium GN configuration during the Qt build, not only runtime
# Chromium flags.

QT_VERSION="${QT_VERSION:-6.11.2}"
PREFIX="${QT_INSTALL_PREFIX:-$PWD/qt-webgpu}"
QT_SRC="${QT_SRC:-qt6}"
QT_CONFIGURE_BUILD="${QT_CONFIGURE_BUILD:-qt-build}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
QTWEBENGINE_SRC="${QTWEBENGINE_SRC:-$QT_SRC/qtwebengine}"

if [ ! -d "$QT_SRC/.git" ]; then
    git clone --branch "v${QT_VERSION}" --depth 1 \
        https://github.com/qt/qt5.git "$QT_SRC"
fi

if [ ! -f "$QTWEBENGINE_SRC/CMakeLists.txt" ]; then
    (
        cd "$QT_SRC"
        ./init-repository \
            --module-subset=qtwebengine,qtshadertools \
            --no-optional-deps \
            --ignore-submodules
    )
fi

if [ ! -f "$QT_SRC/qtshadertools/CMakeLists.txt" ]; then
    git -C "$QT_SRC" submodule update --init --depth 1 qtshadertools
fi

bash "$SCRIPT_DIR/patch_qtwebengine_webgpu.sh" "$QTWEBENGINE_SRC"

export QTWEBENGINE_CHROMIUM_FLAGS="--enable-unsafe-webgpu --ignore-gpu-blocklist"
export QTWEBENGINE_CHROMIUM_FLAGS="$QTWEBENGINE_CHROMIUM_FLAGS --enable-features=WebGPU --enable-dawn-features=allow_unsafe_apis"

mkdir -p "$QT_CONFIGURE_BUILD"
cd "$QT_CONFIGURE_BUILD"

"../$QT_SRC/configure" \
    -release \
    -prefix "$PREFIX" \
    -opensource \
    -confirm-license \
    -nomake examples \
    -nomake tests \
    -submodules qtwebengine \
    -webengine-proprietary-codecs \
    -webengine-webrtc \
    -- \
    -DQT_NO_XCODE_MIN_VERSION_CHECK=ON

cmake --build . --parallel
cmake --install .

echo "Installed Qt 6.11.2 + QtWebEngine WebGPU build to $PREFIX"
