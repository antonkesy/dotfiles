#!/bin/zsh

sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo snap refresh
sudo flatpak update -y
