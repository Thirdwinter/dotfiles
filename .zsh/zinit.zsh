ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-syntax-highlighting
# zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-autosuggestions
# zinit ice depth"1"
# zinit light romkatv/powerlevel10k
zinit light Aloxaf/fzf-tab

# zinit snippet OMZP::sudo

zinit cdreplay -q
