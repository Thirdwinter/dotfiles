#!/bin/bash

# 获取所有 tmux 会话列表
sessions=$(tmux ls -F "#{session_name}")

# 定义一个空的选项列表
options=""

# 循环遍历每个会话
for session in $sessions; do
  # 获取会话中的所有窗口
  windows=$(tmux list-windows -t "$session" -F "#{window_index}:#{window_name}")

  # 循环遍历每个窗口
  for window in $windows; do
    window_index=$(echo "$window" | cut -d: -f1)
    window_name=$(echo "$window" | cut -d: -f2)
    # 获取窗口中的所有子窗口
    panes=$(tmux list-panes -t "$session:$window_index" -F "#{pane_index}:#{pane_title}")

    # 如果没有子窗口，直接添加会话和窗口信息
    if [ $(echo "$panes" | wc -l) -eq 1 ]; then
      options+="session: $session - window: $window_index:$window_name\n"
    else
      # 循环遍历每个子窗口
      for pane in $panes; do
        pane_index=$(echo "$pane" | cut -d: -f1)
        pane_title=$(echo "$pane" | cut -d: -f2)
        options+="session: $session - window: $window_index:$window_name - pane: $pane_index\n"
      done
    fi
  done
done

# 去除最后一个换行符
options=$(echo -e "$options" | sed '/^\s*$/d')

# 使用 rofi 选择一个选项
selected_option=$(echo -e "$options" | rofi -dmenu -p "Select tmux session/window/pane:")

# 检查是否选择了一个选项
if [ -n "$selected_option" ]; then
  # 解析选中的选项
  selected_session=$(echo "$selected_option" | awk -F' - ' '{print $1}' | cut -d' ' -f2)
  selected_window=$(echo "$selected_option" | awk -F' - ' '{print $2}' | cut -d' ' -f2 | cut -d':' -f1)
  selected_pane=$(echo "$selected_option" | awk -F' - ' '{print $3}' | cut -d' ' -f2)

  # 获取窗口索引
  window_index=$(tmux list-windows -t "$selected_session" -F "#{window_index}:#{window_name}" | grep -E "^$selected_window:" | cut -d: -f1)

  # 如果没有指定pane，直接进入窗口
  if [ -z "$selected_pane" ]; then
    kitty tmux attach-session -t "$selected_session" \; select-window -t "$window_index"
  else
    # 使用 kitty 打开选中的 tmux 会话、窗口和子窗口
    kitty tmux attach-session -t "$selected_session" \; select-window -t "$window_index" \; select-pane -t "$selected_pane"
  fi
else
  echo "No tmux session/window/pane selected."
fi
