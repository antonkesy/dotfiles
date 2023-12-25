#!/bin/bash

apt-get install ninja-build gettext cmake unzip curl  cmake
cd neovim && 
make CMAKE_BUILD_TYPE=RelWithDebInfo &&
make install &&
cd ..
