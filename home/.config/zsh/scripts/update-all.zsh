#!/bin/zsh
# Update everything nix does not pin: the flake inputs, then rebuild.
set -e

DOTFILES="${DOTFILES:-$HOME/Projects/dotfiles}"

cd "$DOTFILES"
nix flake update
sudo nixos-rebuild switch --flake ".#$(hostname)"
nix store gc

# Toolchains that manage their own mutable state on purpose.
command -v rustup >/dev/null && rustup update
command -v cargo-install-update >/dev/null && cargo install-update -a
flatpak update -y

# hyprpm leaves its clone of the Hyprland source under the runtime dir, and a
# build interrupted mid-run (or a leftover CMake progress file) makes the next
# `update` abort with a filesystem-permission error instead of just re-cloning.
# Clear it first so this never needs a manual fix, and don't let a hyprpm
# failure take down the rest of the script (set -e is active above).
if command -v hyprpm >/dev/null; then
    rm -rf "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/hyprpm"
    hyprpm update || true
fi
