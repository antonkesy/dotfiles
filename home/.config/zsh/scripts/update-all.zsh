#!/bin/zsh

# User-level update: home-manager (all software + dotfiles) and the things
# that still manage themselves next to it. System packages: sudo-update-all.

DOTFILES="${DOTFILES:-$HOME/Projects/dotfiles}"

if [ -e /etc/NIXOS ]; then
	echo "NixOS: home-manager is part of the system generation -> sudo-update-all"
else
	(cd "$DOTFILES" && nix flake update && nix run .#home-manager -- switch --flake ".#$(hostname)" -b hm-bak)
fi

zsh -ic "zinit update --all"

if command -v hyprpm >/dev/null 2>&1 && [ ! -e /etc/NIXOS ]; then
	hyprpm update
fi
