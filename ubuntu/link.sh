#!/bin/bash

echo "WARNING: run this script from dotfiles repository root directory"
sudo ln --symbolic --force "$(pwd)/ubuntu/etc/default/grub" "/etc/default/grub"
sudo ln --symbolic --force "$(pwd)/ubuntu/etc/gdm3/custom.conf" "/etc/gdm3/custom.conf"

sudo update-grub
