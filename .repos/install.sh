#!/bin/bash

# TODO install local repos

# sensor
sudo apt install lm-sensors

# neovim
# https://github.com/neovim/neovim
sudo apt-get install ninja-build gettext cmake unzip curl
sudo apt install cmake
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd ..

