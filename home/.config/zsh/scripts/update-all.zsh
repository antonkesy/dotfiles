#!/bin/zsh

DOTFILES="${DOTFILES:-$HOME/Projects/dotfiles}"

(cd "$DOTFILES/home" && make update switch)

# not -i: an interactive shell on WSL would attach to tmux
zsh -c 'source ~/.zinit/bin/zinit.zsh && zinit update --all'

if command -v hyprpm >/dev/null 2>&1; then
	hyprpm update
fi
