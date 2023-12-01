#!/bin/bash

sudo apt-get install -y git ninja-build gettext cmake unzip curl cmake &&
git clone --branch release-0.9 https://github.com/neovim/neovim.git &&
cd neovim && 
sudo make CMAKE_BUILD_TYPE=RelWithDebInfo &&
sudo make install &&
cd ..
