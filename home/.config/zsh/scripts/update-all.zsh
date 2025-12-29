#!/bin/zsh

yay -Syu --noconfirm
cargo install-update -a
pipx upgrade-all
rustup update && rustup upgrade
stack update && stack upgrade
zsh -ic "omz update"
