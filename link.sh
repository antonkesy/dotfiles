#!/bin/bash

# Create non-tracked zsh config file for device-specific settings
touch ./home/.config/zsh/untracked.zsh

dirs_to_link=(
    ".config/lvim/lua/"
    ".config/alacritty/"
    ".config/zsh/"
    ".tmux/plugins/tpm/"
)

rm ~/.config/zsh -rf

for item in "${dirs_to_link[@]}"; do
    from="$(pwd)/home/$item"
    to="$HOME/$(dirname "$item")"
    dirname=$(basename "$from")

    echo "DIRECTORY: $from -> $to"
    mkdir -p "${to}"
    unlink "${to}"/"${dirname}"
    ln --symbolic "${from}" --target-directory="${to}"
done

# ----------------------------------------------------------------------------------------------------

mkdir -p "$HOME/.config/lvim/spell"

files_to_link=(
    ".config/monitors.xml"
    ".config/lvim/config.lua"
    ".config/gSnap/layouts.json"
    ".spacemacs"
    ".tmux.conf"
    ".zshrc"
)

mkdir "${HOME}"/.config/gSnap/

for item in "${files_to_link[@]}"; do
    from="$(pwd)/home/$item"
    to=$HOME/$item
    echo "FILE: $from -> $to"
    ln --symbolic --force "$from" "$to"
done
