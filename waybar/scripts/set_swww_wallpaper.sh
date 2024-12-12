#!/bin/bash

set_wallpaper_hyprland() {
	dir="$HOME/Pictures/wallpapers"
	BG="$(find "$dir" -name '*.jpg' -o -name '*.png' | shuf -n1)"
	PROGRAM="swww-daemon"
	trans_type="grow"

	if pgrep "$PROGRAM" >/dev/null; then
		swww img "$BG" --transition-fps 244 --transition-type $trans_type --transition-duration 1 --transition-pos top-right
	else
		swww init && swww img "$BG" --transition-fps 244 --transition-type $trans_type --transition-duration 1 --transition-pos top-right

	fi
}

set_wallpaper_hyprland
