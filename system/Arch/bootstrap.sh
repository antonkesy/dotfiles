#!/bin/bash
# Phase 2 of a fresh Arch install (after install.sh and the reboot): pacman
# prerequisites, clone this repo into ~/Projects/dotfiles (load-bearing:
# home-manager symlinks ~/.config into it), then `make arch` -- the system half
# via ansible, ending in home-manager switch for everything under ~.
#
#   curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Arch/bootstrap.sh | bash
#   curl -fsSL ... | HOST=ak bash            # profile (ansible/hosts/<name>.yml)
#   HOST=ak bash system/Arch/bootstrap.sh    # from a checkout
set -euo pipefail

PROJECTS="${PROJECTS:-$HOME/Projects}"
DOTFILES="$PROJECTS/dotfiles"
HOST="${HOST:-$(hostname)}"

sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed base-devel git make ansible

mkdir -p "$PROJECTS"
[ -d "$DOTFILES" ] || git clone --recursive https://github.com/antonkesy/dotfiles.git "$DOTFILES"
git -C "$DOTFILES" submodule update --init --recursive

cd "$DOTFILES"
make arch HOST="$HOST"

echo "Done. Reboot into the greeter. Hyprland plugins: system/Arch/manual/hyprpm.sh (needs a running Hyprland)."
