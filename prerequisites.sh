#!/bin/bash

set -e

echo "Check if sudo is installed"
sudo --version || {
    echo "sudo is not installed. Please install sudo and re-run the script."
  }


sudo pacman -S --noconfirm --needed sudo
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed base-devel git sudo zsh tzdata
sudo pacman -Scc --noconfirm
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm ansible
