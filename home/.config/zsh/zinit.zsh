#!/bin/zsh

# Install Zinit if not already installed
if ! [ -f ~/.zinit/bin/zinit.zsh ]; then
  mkdir -p ~/.zinit && git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
fi

# Source Zinit
source ~/.zinit/bin/zinit.zsh

# Load oh-my-zsh framework
zinit light ohmyzsh/ohmyzsh

# zsh theme
zinit light romkatv/powerlevel10k

zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light thetic/extract

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode # Breaks auto-complete in insert mode; keep an eye on this
ZVM_VI_EDITOR=nvim # vv in normal mode -> opens nvim

autoload -Uz promptinit; promptinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust
