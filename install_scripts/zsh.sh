#!/bin/bash

sudo apt install unzip

# hack font
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip
sudo unzip ./Hack.zip -d /usr/share/fonts/truetype/
sudo fc-cache -f -v
rm ./Hack.zip

# starship theme
# https://starship.rs/
curl -sS https://starship.rs/install.sh | sh

sudo apt install zsh -y
# set zsh as default shell
chsh -s $(which zsh)


# https://github.com/ohmyzsh/ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Note that any previous .zshrc will be renamed to .zshrc.pre-oh-my-zsh. After installation, you can move the configuration you want to preserve into the new .zshrc.
