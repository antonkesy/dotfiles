#!/bin/bash
# https://www.lunarvim.org/docs/installation

sudo apt install python3-pynvim
bash ~/.local/share/lunarvim/lvim/utils/installer/uninstall.sh

sudo apt-get -y install luarocks xclip && \
bash <(curl -s https://raw.githubusercontent.com/ChristianChiarulli/LunarVim/master/utils/installer/install.sh) --no-interaction --yes && \
pip install neovim

# LSP Dependencies
sudo apt install nodejs npm -y
sudo apt-get install ruby-dev -y
sudo apt install r-base -y
sudo apt install php libapache2-mod-php php-cli php-cgi unzip -y
