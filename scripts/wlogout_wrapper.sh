#!/bin/bash
# Check if wlogout is already running
if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

# Detect monitor resolution and scaling factor
# resolution=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .height / .scale' | awk -F'.' '{print $1}')
# hypr_scale=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .scale')
wlogout --protocol layer-shell -b 5 -T 300 -B 300 > /dev/null
