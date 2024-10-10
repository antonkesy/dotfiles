#!/bin/bash

dirs_to_link=(
    ".config/lvim/lua/"
    ".config/alacritty/"
    ".repos/antigen/"
    ".tmux/plugins/tpm/"
)

for item in ${dirs_to_link[@]}; do
    from="$(pwd)/$item"
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
    ".antigenrc"
    ".tmux.conf"
    ".zshrc"
)

mkdir ${HOME}/.config/gSnap/

for item in ${files_to_link[@]}; do
    from="$(pwd)/$item"
    to=$HOME/$item
    echo "FILE: $from -> $to"
    ln --symbolic --force "$from" "$to"
done
