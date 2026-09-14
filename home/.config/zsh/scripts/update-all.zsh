#!/bin/zsh

DOTFILES="${DOTFILES:-$HOME/Projects/dotfiles}"

(cd "$DOTFILES/home" && make update switch)

zsh -ic "zinit update --all"

if command -v hyprpm >/dev/null 2>&1; then
	hyprpm update
fi
