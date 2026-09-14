#!/bin/bash
# Phase 2 of a fresh Arch install: prerequisites, clone into
# ~/Projects/dotfiles (load-bearing), then `make arch`.
#
#   curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Arch/bootstrap.sh | bash
#   bash system/Arch/bootstrap.sh            # from a checkout
set -euo pipefail

PROJECTS="${PROJECTS:-$HOME/Projects}"
DOTFILES="$PROJECTS/dotfiles"

sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed base-devel git make ansible

mkdir -p "$PROJECTS"
[ -d "$DOTFILES" ] || git clone --recursive https://github.com/antonkesy/dotfiles.git "$DOTFILES"
git -C "$DOTFILES" submodule update --init --recursive

cd "$DOTFILES"
make arch

echo "Done. Reboot into the greeter. Hyprland plugins: system/Arch/manual/hyprpm.sh (needs a running Hyprland)."
