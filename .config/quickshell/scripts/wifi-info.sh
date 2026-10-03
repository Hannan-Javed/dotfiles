#!/bin/sh

IF=$(nmcli -t -f DEVICE,TYPE device | awk -F: '$2=="wifi"{print $1; exit}')

if [ -z "$IF" ]; then
    echo "Disconnected|0|--|--"
    exit 0
fi

SSID=$(nmcli -t -f active,ssid dev wifi \
    | awk -F: '/^yes:/ {print $2; found=1} END {if(!found) print "Disconnected"}')

SIGNAL=$(nmcli -t -f active,signal dev wifi \
    | awk -F: '/^yes:/ {print $2; exit}')

echo "$SSID|${SIGNAL:-0}"

# RX=$(iw dev "$IF" link | awk '/rx bitrate/ {printf "%.3g", $3/8; exit}')
# TX=$(iw dev "$IF" link | awk '/tx bitrate/ {printf "%.3g", $3/8; exit}')

# echo "$SSID|${SIGNAL:-0}|${RX:- --}|${TX:- --}"