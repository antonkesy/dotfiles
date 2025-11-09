#!/bin/bash
set -e

if [ -f /etc/arch-release ]; then
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm python python-yaml
elif command -v lsb_release >/dev/null && [ "$(lsb_release -si)" = "Ubuntu" ]; then
    sudo apt update -y
    sudo apt install -y python3-yaml
else
    echo "unsupported distro"
    exit 1
fi
