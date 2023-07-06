#!/bin/bash

sudo apt install zsh -y
# set zsh as default shell
chsh -s $(which zsh)

# https://github.com/ohmyzsh/ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Note that any previous .zshrc will be renamed to .zshrc.pre-oh-my-zsh. After installation, you can move the configuration you want to preserve into the new .zshrc.
