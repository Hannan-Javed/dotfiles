#!/usr/bin/env bash

set -euo pipefail

THEME="$1"
STYLE_DIR="$2"
EXTENSION="${3:-conf}"

SOURCE_FILE="$STYLE_DIR/styles/$THEME.$EXTENSION"
TARGET_FILE="$STYLE_DIR/current-style.$EXTENSION"

[[ -f "$SOURCE_FILE" ]] || {
    echo "Theme file not found: $SOURCE_FILE" >&2
    exit 1
}

cp "$SOURCE_FILE" "$TARGET_FILE"