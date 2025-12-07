#!/bin/zsh
# zmodload zsh/zprof # benchmark 1/2

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


export ZSH_DISABLE_COMPFIX=true

export HISTFILE=~/.histfile
export HISTSIZE=50000000
export SAVEHIST=50000000

source ${HOME}/.config/zsh/untracked.zsh
source ${HOME}/.config/zsh/alias.zsh
source ${HOME}/.config/zsh/znap.zsh
source ${HOME}/.config/zsh/zinit.zsh
source ${HOME}/.config/zsh/path.zsh
source ${HOME}/.config/zsh/tmux.zsh
source ${HOME}/.config/zsh/android.zsh
source ${HOME}/.config/zsh/dart.zsh
source ${HOME}/.config/zsh/flutter.zsh
source ${HOME}/.config/zsh/go.zsh
source ${HOME}/.config/zsh/haskell.zsh
source ${HOME}/.config/zsh/taco.zsh
source ${HOME}/.config/zsh/sdkman.zsh
source ${HOME}/.config/zsh/atuin.zsh
source ${HOME}/.config/zsh/scripts.zsh
source ${HOME}/.config/zsh/p10k.zsh
source ${HOME}/.config/zsh/opam.zsh
source ${HOME}/.config/zsh/rust.zsh

# aliases have to be last to avoid conflicts with OMZ defaults
source ${HOME}/.config/zsh/alias.zsh

# zprof # benchmark 2/2

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
