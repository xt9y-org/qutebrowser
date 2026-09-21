#!/usr/bin/env bash

set -euo pipefail

# Prepare a QtWebEngine source tree for WebGPU debugging.
# This does not hide failures behind runtime flags: it enables Chromium/Dawn
# logging so adapter creation failures can be fixed at the correct layer.

SRC="${1:-${QTWEBENGINE_SRC:-qt6/qtwebengine}}"
CORE_CMAKE="$SRC/src/core/CMakeLists.txt"

if [ ! -f "$CORE_CMAKE" ]; then
    echo "Missing QtWebEngine source: $SRC" >&2
    exit 1
fi

if grep -q '^[[:space:]]*use_dawn=true$' "$CORE_CMAKE"; then
    echo "QtWebEngine Dawn patch already applied: $SRC"
    exit 0
fi

if ! grep -q '^[[:space:]]*use_dawn=false$' "$CORE_CMAKE"; then
    echo "Could not find QtWebEngine's expected use_dawn=false GN argument" >&2
    exit 1
fi

git -C "$SRC" apply <<'PATCH'
diff --git a/src/core/CMakeLists.txt b/src/core/CMakeLists.txt
--- a/src/core/CMakeLists.txt
+++ b/src/core/CMakeLists.txt
@@ -385,7 +385,7 @@ foreach(config ${configs})
             toolkit_views=false
             pdf_use_skia=true
             use_cups=false
-            use_dawn=false
+            use_dawn=true
             skia_use_dawn=false
             dawn_use_built_dxc=false
             use_static_angle=true
PATCH

echo "Enabled Dawn in QtWebEngine Chromium GN configuration: $SRC"
