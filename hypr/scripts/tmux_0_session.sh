#!/bin/bash
  # 启动一个新的 Kitty 终端并检查 tmux 会话
  kitty sh -c "tmux has-session -t 0 2>/dev/null; if [ \$? != 0 ]; then tmux new-session -s 0; else tmux attach-session -t 0; fi"
