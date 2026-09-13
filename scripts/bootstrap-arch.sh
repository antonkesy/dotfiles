#!/usr/bin/env sh
set -eu

mkdir -p ~/Projects/ && cd ~/Projects/
git clone --recursive https://github.com/antonkesy/dotfiles.git
cd dotfiles
make desktop

echo "Please reboot the machine"
