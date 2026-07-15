#!/bin/zsh

yay -Syu --noconfirm
cargo install-update -a
pipx upgrade-all
stack update && stack upgrade
zsh -ic "omz update"
hyprpm update
