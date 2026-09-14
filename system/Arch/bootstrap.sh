#!/bin/bash
# curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Arch/bootstrap.sh | bash
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

echo "Done. Reboot."
