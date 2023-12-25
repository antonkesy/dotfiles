#!/bin/bash

# working nvidia driver with 22.10 Ubuntu and Razer Core X Chroma
apt install nvidia-driver-535-open nvidia-utils-535 -y

apt install nvidia-cuda-toolkit -y
prime-select nvidia
