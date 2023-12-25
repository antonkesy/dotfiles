#!/bin/bash

echo "WARNING: run this script from dotfiles repository root directory"
ln --symbolic --force "$(pwd)/ubuntu/etc/default/grub" "/etc/default/grub"
ln --symbolic --force "$(pwd)/ubuntu/etc/gdm3/custom.conf" "/etc/gdm3/custom.conf"

update-grub
