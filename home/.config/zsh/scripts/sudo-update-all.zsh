#!/bin/zsh

# System-level update, whatever the distro. The system half itself lives in
# ~/Projects/dotfiles/system/<Distro>; re-run `make arch` there for changes.

if command -v pacman >/dev/null 2>&1; then
	sudo pacman -Syu --noconfirm
elif command -v apt-get >/dev/null 2>&1; then
	sudo apt-get update && sudo apt-get upgrade -y
fi

if command -v flatpak >/dev/null 2>&1; then
	sudo flatpak update -y
fi
