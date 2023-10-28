#!/bin/bash

sudo apt install luarocks xclip

# https://www.lunarvim.org/docs/installation
bash ~/.local/share/lunarvim/lvim/utils/installer/uninstall.sh
# LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) --yes
pip install neovim

# vale (https://github.com/errata-ai/vale)
pip install vale
cd ~
vale sync
cd -
