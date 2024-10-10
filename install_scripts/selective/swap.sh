#!/bin/bash

sudo fallocate -l 100G /swapfile &&
sudo ls -lh /swapfile &&
sudo chmod 600 /swapfile &&
sudo mkswap /swapfile &&
sudo swapon /swapfile &&
sudo cp /etc/fstab /etc/fstab.bak &&
sudo echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
