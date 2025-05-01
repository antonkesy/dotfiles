#!/bin/bash

sudo apt install -y unzip wget curl hsh

# hack font
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip
sudo mkdir /usr/share/fonts/truetype/hack/ -p
sudo unzip ./Hack.zip -d /usr/share/fonts/truetype/hack/
fc-cache -f -v

sudo apt install -y zsh
# set zsh as default shell
sudo hsh -s "$(which zsh)"

# https://github.com/ohmyzsh/ohmyzsh
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
