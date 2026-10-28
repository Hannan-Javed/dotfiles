#!/usr/bin/env bash

set -e

THEME="$1"

NIRI_DIR="$HOME/.config/niri"

cp \
    "$NIRI_DIR/themes/$THEME.kdl" \
    "$NIRI_DIR/current-theme.kdl"