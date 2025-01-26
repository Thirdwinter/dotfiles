# load p10k prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# if [[ -d $HOME/.zsh ]]; then
#   for file in $HOME/.zsh/*.zsh; do
#     if [[ -f $file && -r $file ]]; then
#       source $file
#     fi
#   done
# else
#   echo "zsh extend files not found!" >&2
# fi

source $HOME/.zsh/options.zsh
source $HOME/.zsh/env.zsh
source $HOME/.zsh/zinit.zsh
source $HOME/.zsh/utility.zsh
source $HOME/.zsh/aliases.zsh
source $HOME/.zsh/keybinds.zsh
source $HOME/.zsh/fzf.zsh
source $HOME/.zsh/zoxide.zsh
source $HOME/.zsh/direnv.zsh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# eval "$(starship init zsh)"
