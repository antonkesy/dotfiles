#!/bin/bash

VERSION=550 # TODO: increase due to theme bug

# working nvidia driver with 24.04.1 Ubuntu and Razer Core X Chroma
sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo apt update -y
sudo apt upgrade -y
sudo apt remove 'nvidia-*' -y
sudo apt-get install nvidia-driver-${VERSION}-open nvidia-utils-${VERSION} nvidia-cuda-toolkit -y
sudo prime-select nvidia
