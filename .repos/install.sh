#!/bin/bash

# neovim
# https://github.com/neovim/neovim
# use .9 for lunarvim (might be fixed now)
sudo apt-get install ninja-build gettext cmake unzip curl
sudo apt install cmake
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd ..


# sensor
sudo apt install lm-sensors

# extensions
sudo add-apt-repository universe
sudo apt install gnome-shell-extensions gnome-tweaks
mkdir -p ~/.local/share/gnome-shell/extensions/
cp ./gnome-shell-extension-* ~/.local/share/gnome-shell/extensions/ -r
# gnome-extensions enable clipboard-indicator@tudmotu.com # manually enable in gnome-tweak-tool -> extensions
# https://github.com/UshakovVasilii/gnome-shell-extension-freon/wiki
# gnome-extensions enable sensors@tudmotu.com # manually enable in gnome-tweak-tool -> extensions

