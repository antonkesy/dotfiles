#!/bin/zsh

# Install Zinit if not already installed
if ! [ -f ~/.zinit/bin/zinit.zsh ]; then
	mkdir -p ~/.zinit && git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
fi

# Source Zinit
source ~/.zinit/bin/zinit.zsh

# zsh theme
zinit light romkatv/powerlevel10k

zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light thetic/extract

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode # Breaks auto-complete in insert mode; keep an eye on this
ZVM_VI_EDITOR=nvim                 # vv in normal mode -> opens nvim

autoload -Uz promptinit
promptinit

# completion: one compinit, one dump; -C skips the compaudit (ZSH_DISABLE_COMPFIX)
[[ -d ${XDG_CACHE_HOME:-$HOME/.cache}/zsh ]] || mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
autoload -Uz compinit
compinit -C -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compdump"
zinit cdreplay -q
