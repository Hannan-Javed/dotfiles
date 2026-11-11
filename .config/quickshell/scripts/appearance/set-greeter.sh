#!/usr/bin/env bash

set -euo pipefail

STYLE_PATH="$(dirname "$HOME/.config/quickshell/greeter/styles/$1")"

SOURCE_ROOT="$HOME/.config/quickshell/greeter"
TARGET_DIR="/var/cache/qs-greeter/current-greeter"


[[ -d "$STYLE_PATH" ]] || {
    echo "Style directory not found: $STYLE_PATH" >&2
    exit 1
}

mkdir -p "$TARGET_DIR"

#
# Remove everything currently in current-greeter
#
find "$TARGET_DIR" \
    -mindepth 1 \
    -exec rm -rf {} +

#
# Copy shared greeter files such as LoginManager, LoginState
#
find "$SOURCE_ROOT"/shared \
    -maxdepth 1 \
    -type f \
    -name '*.qml' \
    -exec cp {} "$TARGET_DIR"/ \;

#
# Copy style contents
#
cp -r "$STYLE_PATH"/. "$TARGET_DIR"/
echo "Greeter published to $TARGET_DIR"
