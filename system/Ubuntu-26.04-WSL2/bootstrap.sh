#!/bin/bash
# Ubuntu-26.04-WSL2: the small system half (apt, zsh as login shell,
# /etc/wsl.conf), single-user nix (--no-daemon: no nix-daemon, no systemd
# needed), then `make home` from this repo owns everything under ~.
#
#   curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Ubuntu-26.04-WSL2/bootstrap.sh | bash
#   make wsl                                  # from a checkout (re-runnable)
set -euo pipefail

PROJECTS="${PROJECTS:-$HOME/Projects}"
DOTFILES="$PROJECTS/dotfiles"
ME="$(id -un)"

sudo apt-get update
sudo apt-get install -y git curl make xz-utils ca-certificates zsh

# The distro zsh stays the login shell (works even if nix is unavailable); it
# runs the same .zshrc that home-manager links.
if [ "$(getent passwd "$ME" | cut -d: -f7)" != "/usr/bin/zsh" ]; then
	sudo chsh -s /usr/bin/zsh "$ME"
fi

# WSL: systemd for home-manager's user units (ssh-agent, gpg-agent), no
# Windows PATH noise, log in as this user. Only written once; takes effect
# after `wsl --shutdown` from Windows.
if grep -qi microsoft /proc/version 2>/dev/null && [ ! -e /etc/wsl.conf ]; then
	printf '[boot]\nsystemd=true\n\n[interop]\nappendWindowsPath=false\n\n[user]\ndefault=%s\n' "$ME" |
		sudo tee /etc/wsl.conf >/dev/null
	echo "wrote /etc/wsl.conf: run 'wsl --shutdown' from Windows after this script finishes."
fi

if [ ! -x "$HOME/.nix-profile/bin/nix" ]; then
	curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --no-daemon
fi
# The installer only wires nix into *future* shells; load it into this one.
# shellcheck disable=SC1091
. "$HOME/.nix-profile/etc/profile.d/nix.sh"

mkdir -p "$PROJECTS"
[ -d "$DOTFILES" ] || git clone --recursive https://github.com/antonkesy/dotfiles.git "$DOTFILES"
git -C "$DOTFILES" submodule update --init --recursive

# The root Makefile forwards to home/Makefile, which exports NIX_CONFIG (flakes)
# and runs home-manager from the flake's pinned input when it is not on PATH yet.
cd "$DOTFILES"
make home

echo "Done. Log out and back in once for the session variables."
