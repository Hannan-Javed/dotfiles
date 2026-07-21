#!/usr/bin/env bash

if pgrep -x "hyprsunset" > /dev/null; then
    pkill hyprsunset
    notify-send -u low -t 1000 "Hyprsunset" "Night Light Disabled"
else
    # Set your preferred color temperature (e.g., 4000 or 5500)
    hyprsunset -t 4500 &
    notify-send -u low -t 1000 "Hyprsunset" "Night Light Enabled"
fi

# Refresh Waybar to update the icon
pkill -SIGRTMIN+10 waybar
