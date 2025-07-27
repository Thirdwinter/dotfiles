#!/bin/bash

SESSION_NAME="music"
COMMAND="musicfox"

kitty --class "go-musicfox" tmux new-session -A -s $SESSION_NAME $COMMAND \
    \; split-window -v \
    \; resize-pane -y 30% \
    \; send-keys 'cava' Enter \
    \; select-pane -t '{top}'
