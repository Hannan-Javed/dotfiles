#!/usr/bin/env bash

set -e

WALLPAPER="$1"

# attach home if not already present
if [[ "$WALLPAPER" == ~* ]]; then
    WALLPAPER="${WALLPAPER/#\~/$HOME}"
elif [[ "$WALLPAPER" != /* ]]; then
    WALLPAPER="$HOME/$WALLPAPER"
fi
if [[ ! -f "$WALLPAPER" ]]; then
    echo "Wallpaper not found: $WALLPAPER" >&2
    exit 1
fi

# FIXED: Extract the file extension from the incoming path (e.g., png or jpg)
EXT="${WALLPAPER##*.}"

CACHE_DIR="$HOME/.cache/quickshell"
# FIXED: Dynamic blurred filename extension
BLUR_WALL="$CACHE_DIR/current-wallpaper-blur.$EXT"

mkdir -p "$CACHE_DIR"

# Generate the blurred version in the background
magick "$WALLPAPER" \
    -blur 0x10 \
    "$BLUR_WALL"

TRANSITIONS=(
    wipe
    grow
    outer
    any
)

TRANSITION=${TRANSITIONS[$RANDOM % ${#TRANSITIONS[@]}]}

awww img "$WALLPAPER" \
    --transition-type "$TRANSITION"

pkill swaybg || true

swaybg \
    -m fill \
    -i "$BLUR_WALL" &
