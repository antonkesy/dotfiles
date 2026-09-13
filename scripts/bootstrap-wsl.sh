#!/usr/bin/env sh
set -eu

# minimal requirements
sudo apt update -y
sudo apt install -y git make curl

# nix (single-user; WSL without systemd has no daemon)
if ! command -v nix >/dev/null 2>&1; then
	curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --no-daemon
fi
# the installer only wires nix into *future* shells; load it into this one
# shellcheck disable=SC1091
. "$HOME/.nix-profile/etc/profile.d/nix.sh"

mkdir -p ~/Projects && cd ~/Projects
[ -d dotfiles ] || git clone --recursive https://github.com/antonkesy/dotfiles.git
cd dotfiles
make switch
