#!/usr/bin/bash

# 检查是否有 tmux 会话存在，如果有则重新加载 tmux 配置文件
if [ $(tmux list-sessions | wc -l) -gt 0 ]; then 
    tmux source-file ~/.tmux.conf
fi
