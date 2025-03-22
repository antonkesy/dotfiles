#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

sudo apt-get install -y ninja-build gettext cmake unzip curl cmake
cd ${SCRIPT_DIR}/neovim &&
  sudo rm .deps build -rf &&
  sudo make CMAKE_BUILD_TYPE=RelWithDebInfo &&
  sudo make install &&
cd ..
