#!/bin/bash
# curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Ubuntu-26.04-WSL2/bootstrap.sh | bash
set -euo pipefail

PROJECTS="${PROJECTS:-$HOME/Projects}"
DOTFILES="$PROJECTS/dotfiles"
ME="$(id -un)"

sudo apt-get update
sudo apt-get install -y git curl make xz-utils ca-certificates zsh

if [ "$(getent passwd "$ME" | cut -d: -f7)" != "/usr/bin/zsh" ]; then
	sudo chsh -s /usr/bin/zsh "$ME"
fi

if grep -qi microsoft /proc/version 2>/dev/null && [ ! -e /etc/wsl.conf ]; then
	printf '[boot]\nsystemd=true\n\n[interop]\nappendWindowsPath=false\n\n[user]\ndefault=%s\n' "$ME" |
		sudo tee /etc/wsl.conf >/dev/null
	echo "wrote /etc/wsl.conf: run 'wsl --shutdown' from Windows after this script finishes."
fi

if [ ! -x "$HOME/.nix-profile/bin/nix" ]; then
	curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --no-daemon
fi
# shellcheck disable=SC1091
. "$HOME/.nix-profile/etc/profile.d/nix.sh"

mkdir -p "$PROJECTS"
[ -d "$DOTFILES" ] || git clone --recursive https://github.com/antonkesy/dotfiles.git "$DOTFILES"
git -C "$DOTFILES" submodule update --init --recursive

cd "$DOTFILES"
make home

echo "Done. Log out and back in once."
