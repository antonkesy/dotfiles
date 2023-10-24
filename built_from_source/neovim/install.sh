#!/bin/bash
sudo apt-get install ninja-build gettext cmake unzip curl  cmake
cd neovim && 
sudo make CMAKE_BUILD_TYPE=RelWithDebInfo &&
sudo make install &&
cd ..
