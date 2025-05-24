#!/bin/bash
# https://www.lunarvim.org/docs/installation

sudo apt install -y python3-pynvim
bash ~/.local/share/lunarvim/lvim/utils/installer/uninstall.sh

sudo apt-get -y install luarocks xclip curl
bash <(curl -s https://raw.githubusercontent.com/ChristianChiarulli/LunarVim/master/utils/installer/install.sh) --no-interaction --yes
pipx install -y neovim

# LSP Dependencies
sudo apt-get install -y npm ruby-dev r-base php libapache2-mod-php php-cli php-cgi unzip llvm-14 lldb-14
