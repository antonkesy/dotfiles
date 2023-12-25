#!/bin/bash

fallocate -l 100G /swapfile &&
ls -lh /swapfile &&
chmod 600 /swapfile &&
mkswap /swapfile &&
swapon /swapfile &&
cp /etc/fstab /etc/fstab.bak &&
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
