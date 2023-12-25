#!/bin/bash

./install_scripts/base.sh
./link.sh
# Source any shell env
. ~/.bashrc
. ~/.zshrc
./built_from_source/neovim/install.sh
./built_from_source/alacritty/install.sh
