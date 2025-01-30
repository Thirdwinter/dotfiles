#!/usr/bin/bash
directory="$HOME/Pictures/wallpapers"

# Check if the directory exists
if [ ! -d "$directory" ]; then
    notify-send -u critical "Failed!" "No such directory found"
    exit 1
fi

# Get wallpapers
files=()
while IFS= read -r -d '' file; do
    files+=("$file")
done < <(find "$directory" -type f -print0)

# Get the number of wallpapers
num_files="${#files[@]}"

# Check if the directory is empty
if [ "$num_files" -eq 0 ]; then
    notify-send -u critical "Failed!" "No wallpaper to switch"
    exit 1
fi

# Get current wallpaper
cur_file=$(<"$HOME/.cache/swww/eDP-1")

# Function to get a random transition position
get_random_pos() {
    positions=("top-left" "top-right" "bottom-left" "bottom-right" "center")
    rand_index=$((RANDOM % ${#positions[@]}))
    echo "${positions[$rand_index]}"
}

# Change wallpaper using swww
for ((i = 0; i < num_files; i++)); do
    if [ "${files[$i]}" == "$cur_file" ]; then
        if ((i == num_files - 1)); then
            next_index=0
        else
            next_index=$((i + 1))
        fi
        random_pos=$(get_random_pos)
        swww img "${files[$next_index]}" --transition-fps 80 --transition-type grow --transition-pos "$random_pos" --transition-duration 1.3 --transition-bezier 0.43,1.19,1,0.4
        break
    fi
done
