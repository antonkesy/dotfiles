#!/bin/bash

dirs_to_link=(
    ".config/lvim/lua/"
    ".repos/antigen/"
    ".tmux/plugins/tpm/"
)

for item in ${dirs_to_link[@]}; do
    from="$(pwd)/$item"
    to="$HOME/$(dirname $item)"
    dirname=$(basename "$from")

    echo "DIRECTORY: $from -> $to"
    mkdir -p ${to}
    unlink ${to}/${dirname}
    ln --symbolic "${from}" --target-directory="${to}"
done

# ----------------------------------------------------------------------------------------------------

mkdir -p "$HOME/.config/alacritty"
mkdir -p "$HOME/.config/lvim/spell"
mkdir -p "$HOME/.local/share/lunarvim/site/pack/lazy/opt/nvim-treesitter/spell"

files_to_link=(
    ".config/alacritty/alacritty.toml"
    ".config/lvim/config.lua"
    ".config/lvim/spell/de.utf-8.spl"
    ".config/lvim/spell/de.utf-8.sug"
    ".local/share/lunarvim/site/pack/lazy/opt/nvim-treesitter/spell/en.utf-8.add"
    ".local/share/lunarvim/site/pack/lazy/opt/nvim-treesitter/spell/en.utf-8.add.spl"
    ".antigenrc"
    ".tmux.conf"
    ".zshrc"
)

for item in ${files_to_link[@]}; do
    from="$(pwd)/$item"
    to=$HOME/$item
    echo "FILE: $from -> $to"
    ln --symbolic --force "$from" "$to"
done
