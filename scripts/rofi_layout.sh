#!/bin/bash

# This script uses rofi to select and change the Hyprland layout

# Get the available layouts in JSON format and parse them
layouts=$(hyprctl layouts -j | jq -r '.[]')

# Get the current layout
current_layout=$(hyprctl getoption general:layout -j | jq -r '.str')

# Prepare the list of options for rofi, marking the current layout
options=$(printf "%s (current)\n" "$current_layout"; printf "%s\n" "${layouts[@]}" | grep -v "^$current_layout\$")

# Use rofi to display the layout options
chosen_layout=$(echo -e "$options" | rofi -dmenu -i -mesg "Choose Hyprland Layout:")

# Function to change the layout based on the user's selection
change_layout() {
    case $1 in
        "dwindle"|"master"|"scroller")
            hyprctl keyword general:layout "$1"
            ;;
        *" (current)")
            echo "Current layout selected."
            ;;
        *)
            echo "Invalid layout selected."
            ;;
    esac
}

# Change the layout if a valid selection was made
if [[ -n $chosen_layout ]]; then
    chosen_layout=$(echo "$chosen_layout" | sed 's/ (current)//')
    change_layout "$chosen_layout"
else
    echo "No layout selected."
fi
