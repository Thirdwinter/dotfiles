# keybindings
bindkey -e

bindkey -s '^o' _fzf_to_config^M

# # 自定义 sudo 行编辑
# zle -N _sudo_command_line
bindkey -M emacs '^k' sudo-command-line

bindkey -s '^s' y^M


for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
