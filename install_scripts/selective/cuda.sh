#!/bin/bash

# working nvidia driver with 22.10 Ubuntu and Razer Core X Chroma
add-apt-repository ppa:graphics-drivers/ppa -y
apt update -y
apt upgrade -y
apt remove 'nvidia-*' -y
apt-get install nvidia-driver-535-open nvidia-utils-535 nvidia-cuda-toolkit -y
prime-select nvidia
