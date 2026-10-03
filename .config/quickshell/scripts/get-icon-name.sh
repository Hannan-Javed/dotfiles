#!/usr/bin/env bash

APP_ID="$1"

[ -z "$APP_ID" ] && exit 1

for file in \
    "$HOME/.local/share/applications/${APP_ID}.desktop" \
    "/usr/share/applications/${APP_ID}.desktop"
do
    if [ -f "$file" ]; then
        grep '^Icon=' "$file" | head -n1 | cut -d= -f2
        exit 0
    fi
done


# Fallback
echo "$APP_ID"