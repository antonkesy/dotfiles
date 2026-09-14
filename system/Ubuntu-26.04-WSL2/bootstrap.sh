#!/bin/bash
# System half (apt, login shell, /etc/wsl.conf) + single-user nix,
# then `make home` for everything under ~.
#
#   curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Ubuntu-26.04-WSL2/bootstrap.sh | bash
#   make wsl                                  # from a checkout (re-runnable)
set -euo pipefail

PROJECTS="${PROJECTS:-$HOME/Projects}"
DOTFILES="$PROJECTS/dotfiles"
ME="$(id -un)"

sudo apt-get update
sudo apt-get install -y git curl make xz-utils ca-certificates zsh

# Distro zsh as login shell: works even without nix, same .zshrc.
if [ "$(getent passwd "$ME" | cut -d: -f7)" != "/usr/bin/zsh" ]; then
	sudo chsh -s /usr/bin/zsh "$ME"
fi

# systemd for home-manager's user units, no Windows PATH noise.
# Written once; needs `wsl --shutdown` to take effect.
if grep -qi microsoft /proc/version 2>/dev/null && [ ! -e /etc/wsl.conf ]; then
	printf '[boot]\nsystemd=true\n\n[interop]\nappendWindowsPath=false\n\n[user]\ndefault=%s\n' "$ME" |
		sudo tee /etc/wsl.conf >/dev/null
	echo "wrote /etc/wsl.conf: run 'wsl --shutdown' from Windows after this script finishes."
fi

if [ ! -x "$HOME/.nix-profile/bin/nix" ]; then
	curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --no-daemon
fi
# the installer only wires nix into future shells
# shellcheck disable=SC1091
. "$HOME/.nix-profile/etc/profile.d/nix.sh"

mkdir -p "$PROJECTS"
[ -d "$DOTFILES" ] || git clone --recursive https://github.com/antonkesy/dotfiles.git "$DOTFILES"
git -C "$DOTFILES" submodule update --init --recursive

# home/Makefile runs home-manager from the flake's pinned input if not on PATH.
cd "$DOTFILES"
make home

echo "Done. Log out and back in once for the session variables."
