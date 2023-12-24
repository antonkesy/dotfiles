#!/bin/bash

mkdir -p "$HOME/.config/alacritty"
mkdir -p "$HOME/.config/lvim/spell"
mkdir -p "$HOME/.local/share/lunarvim/site/pack/lazy/opt/nvim-treesitter/spell"

# dirs_to_link=(
#     ".config/lvim/lua/"
#     ".repos/antigen/"
#     ".tmux/plugins/tpm/"
# )

# TODO: fix this in function below
mkdir -p "${HOME}/.config/lvim/"
ln --symbolic "$(pwd)/.config/lvim/lua/" "${HOME}/.config/lvim/"

mkdir -p "$HOME/.repos"
ln --symbolic "$(pwd)/.repos/antigen/" "${HOME}/.repos"

mkdir -p "$HOME/.tmux/plugins"
ln --symbolic "$(pwd)/.tmux/plugins/tpm/" "${HOME}/.tmux/plugins"

# for item in ${dirs_to_link[@]}; do
#     from="$(pwd)/$item"
#     to="$HOME/$item"

#     filename=$(basename "$from")

#     echo "DIRECTORY: $from -> $to"
#     # TODO: remove dir name from "to" -> 
#     ln --symbolic "$from" --target-directory="$to" &&
#     rm -rf $from/$filename
# done

# ----------------------------------------------------------------------------------------------------

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
