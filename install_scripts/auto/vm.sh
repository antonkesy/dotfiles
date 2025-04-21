#!/bin/bash

sudo apt-get install -y virtualbox

sudo apt-add-repository ppa:flexiondotorg/quickemu -y
sudo apt update -y
sudo apt install quickemu -y

# https://github.com/quickemu-project/quickemu/wiki/04-Create-Windows-virtual-machines
mkdir ~/quickemu -p && cd ~/quickemu || exit
quickget windows 10
# quickemu --vm windows-10.conf
quickget windows 11
# quickemu --vm windows-11.conf
cd - || exit
