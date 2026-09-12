#!/bin/zsh

# System-level update, whatever the distro. The system half of the setup lives
# in ~/Projects/setup; on NixOS that is the whole generation (home-manager
# included).

SETUP="${SETUP:-$HOME/Projects/setup}"

if [ -e /etc/NIXOS ]; then
	(cd "$SETUP" && make switch)
elif command -v pacman >/dev/null 2>&1; then
	sudo pacman -Syu --noconfirm
elif command -v apt-get >/dev/null 2>&1; then
	sudo apt-get update && sudo apt-get upgrade -y
fi

if command -v flatpak >/dev/null 2>&1; then
	sudo flatpak update -y
fi
