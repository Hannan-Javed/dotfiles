#!/usr/bin/env bash

set -e

THEME="$1"

KITTY_DIR="$HOME/.config/kitty"

cp \
    "$KITTY_DIR/themes/$THEME.conf" \
    "$KITTY_DIR/current-theme.conf"

pkill -USR1 kitty || true