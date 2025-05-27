#!/bin/bash
# 使用Kitty启动Tmux，并创建一个新的会话（如果不存在），然后在该会话中执行指定命令

SESSION_NAME="music"
COMMAND="musicfox"

# 使用Kitty启动Tmux，并创建一个新的会话或附加到现有会话
kitty --class "go-musicfox" tmux new-session -A -s $SESSION_NAME $COMMAND
