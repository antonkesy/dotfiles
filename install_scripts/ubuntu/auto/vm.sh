#!/bin/bash

sudo apt-get install -y virtualbox

sudo apt-add-repository ppa:flexiondotorg/quickemu -y
sudo apt update -y
sudo apt install quickemu -y

# https://github.com/quickemu-project/quickemu/wiki/04-Create-Windows-virtual-machines
mkdir ~/quickemu -p && cd ~/quickemu && quickget windows 10 && quickget windows 11 && cd - || exit
# quickemu --vm windows-10.conf
# quickemu --vm windows-11.conf
