#!/bin/bash

# 检查是否有正在运行的 Kitty 终端
if pgrep -x "kitty" > /dev/null; then
  # 使用 overlay 类型启动一个新的 Kitty 终端并检查 tmux 会话
  bash kitty @ launch --self --type=overlay bash -c "tmux has-session -t 0 2>/dev/null; if [ \$? != 0 ]; then tmux new-session -s 0; else tmux attach-session -t 0; fi"
else
  # 启动一个新的 Kitty 终端并检查 tmux 会话
  kitty zsh -c "tmux has-session -t 0 2>/dev/null; if [ \$? != 0 ]; then tmux new-session -s 0; else tmux attach-session -t 0; fi"
fi
