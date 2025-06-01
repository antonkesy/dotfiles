# zmodload zsh/zprof # benchmark 1/2

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


ZSH_DISABLE_COMPFIX=true

HISTFILE=~/.histfile
HISTSIZE=50000000
SAVEHIST=50000000

source ~/.config/zsh/homebrew.zsh
source ~/.config/zsh/fnm.zsh
source ~/.config/zsh/alias.zsh
source ~/.config/zsh/znap.zsh
source ~/.config/zsh/zinit.zsh
source ~/.config/zsh/path.zsh
source ~/.config/zsh/tmux.zsh
source ~/.config/zsh/dart.zsh
source ~/.config/zsh/flatpack.zsh
source ~/.config/zsh/go.zsh
source ~/.config/zsh/haskell.zsh
source ~/.config/zsh/taco.zsh
source ~/.config/zsh/sdkman.zsh
source ~/.config/zsh/atuin.zsh
source ~/.config/zsh/scripts.zsh
source ~/.config/zsh/p10k.zsh

# zprof # benchmark 2/2
