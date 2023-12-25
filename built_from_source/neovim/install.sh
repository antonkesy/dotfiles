#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

apt-get install -y ninja-build gettext cmake unzip curl cmake
cd ${SCRIPT_DIR}/neovim &&
make CMAKE_BUILD_TYPE=RelWithDebInfo &&
make install &&
cd ..
