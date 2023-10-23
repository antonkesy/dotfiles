#!/bin/bash

root_files_to_link=(".config/lvim/config.lua" ".config/Cyberbotics" ".repos" ".antigenrc" ".tmux.conf" ".zshrc")
for item in ${root_files_to_link[@]}; do

  full_item_path="$(pwd)/$item"
  echo "$full_item_path"
  ln --symbolic --force --directory "$full_item_path" "$HOME/$item"
done
