#!/bin/bash
wayfreeze & PID=$!
sleep 0.1
grim -g "$(slurp)" - | wl-copy
kill $PID
wl-paste | satty --filename - --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H%M%S').png
