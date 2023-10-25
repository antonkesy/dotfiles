#!/bin/bash

mkdir -p "$HOME/.tmux/plugins"
mkdir -p "$HOME/.config/alacritty"
mkdir -p "$HOME/.repos"

dirs_to_link=(".repos/antigen/" ".repos/gnome-shell-extension-clipboard-indicator/" ".tmux/plugins/tpm/")

for item in ${dirs_to_link[@]}; do
  from="$(pwd)/$item"
  to="$HOME/.repos/"

  filename=$(basename "$from")

  echo "DIRECTORY: $from -> $to"
  ln --symbolic "$from" --target-directory="$to" &&
  rm -rf $from/$filename
done

# ----------------------------------------------------------------------------------------------------

files_to_link=(".config/alacritty/alacritty.toml" ".config/lvim/config.lua" ".antigenrc" ".tmux.conf" ".zshrc")

for item in ${files_to_link[@]}; do
  from="$(pwd)/$item"
  to=$HOME/$item
  echo "FILE: $from -> $to"
  ln --symbolic --force "$from" "$to"
done
