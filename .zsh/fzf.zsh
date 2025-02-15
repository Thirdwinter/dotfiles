export FZF_DEFAULT_OPTS="
--pointer='█'
--color=fg:#908caa,hl:#ea9a97
--color=fg+:#e0def4,hl+:#ea9a97
--color=border:#44415a,header:#3e8fb0,gutter:#232136
--color=spinner:#f6c177,info:#9ccfd8
--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_COMPLETION_TRIGGER='\'

_fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1"
}


# fzf-tab 集成配置
zstyle ':completion:*' menu no                 # 禁用传统菜单
zstyle ':fzf-tab:*' switch-group '<' '>'       # 分组切换快捷键
# 增强文件预览功能
zstyle ':fzf-tab:complete:*:*' fzf-preview '
  if [[ -f $realpath ]]; then
    bat --color=always $realpath 2>/dev/null || cat $realpath
  elif [[ -d $realpath ]]; then
    lsd -1 --color=always $realpath
fi'
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
