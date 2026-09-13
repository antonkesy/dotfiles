#!/bin/zsh

# User-level update: home-manager (all software + dotfiles) and the things
# that still manage themselves next to it. System packages: sudo-update-all.

DOTFILES="${DOTFILES:-$HOME/Projects/dotfiles}"

(cd "$DOTFILES/home" && make update switch)

zsh -ic "zinit update --all"

if command -v hyprpm >/dev/null 2>&1; then
	hyprpm update
fi
