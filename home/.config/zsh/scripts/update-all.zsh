#!/bin/zsh
# Update everything nix does not pin: the flake inputs, then rebuild.
set -e

DOTFILES="${DOTFILES:-$HOME/workspace/dotfiles}"

cd "$DOTFILES"
nix flake update
sudo nixos-rebuild switch --flake ".#$(hostname)"
nix store gc

# Toolchains that manage their own mutable state on purpose.
command -v rustup >/dev/null && rustup update
command -v cargo-install-update >/dev/null && cargo install-update -a
flatpak update -y
