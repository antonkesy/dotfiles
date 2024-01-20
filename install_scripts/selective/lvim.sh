#!/bin/bash
# https://www.lunarvim.org/docs/installation

apt install python3-pynvim
bash ~/.local/share/lunarvim/lvim/utils/installer/uninstall.sh

apt-get -y install luarocks xclip
bash <(curl -s https://raw.githubusercontent.com/ChristianChiarulli/LunarVim/master/utils/installer/install.sh) --no-interaction --yes
pip install neovim

# LSP Dependencies
apt install nodejs npm -y
apt-get install ruby-dev -y
apt install r-base -y
apt install php libapache2-mod-php php-cli php-cgi unzip -y
