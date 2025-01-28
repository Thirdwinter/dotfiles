# user env
export PATH="$HOME/.local/bin:$PATH"

export TERMINAL="kitty"
export BROWSER="chrome"
export VISUAL="nvim"
export EDITOR="nvim"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CONFIG_DIRS="/etc/xdg"
export XDG_DATA_DIRS="/usr/local/share:/usr/share:/var/lib/flatpak/exports/share:$XDG_DATA_HOME/flatpak/exports/share"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_TEMPLATES_DIR="$HOME/Templates"
export XDG_PUBLICSHARE_DIR="$HOME/Public"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_VIDEOS_DIR="$HOME/Videos"


# # p10k 限制提示符目录长度 方式为限制目录节，最大数量为3
# export POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_last"
# export POWERLEVEL9K_SHORTEN_DIR_LENGTH=3

export WORKON_HOME=~/.WORKON_HOME
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
export VIRTUALENVWRAPPER_SCRIPT=/usr/bin/virtualenvwrapper.sh
source /usr/bin/virtualenvwrapper_lazy.sh
# source /usr/share/nvm/init-nvm.sh
# [ -s "${HOME}/.g/env" ] && \. "${HOME}/.g/env"  # g shell setup
export GOPATH=~/.gopath
export GOBIN=$GOPATH/bin
export GOROOT=/usr/lib/go
export PATH=$PATH:$GOPATH
export PATH=$PATH:$GOBIN
export PATH=$PATH:$GOROOT/bin
