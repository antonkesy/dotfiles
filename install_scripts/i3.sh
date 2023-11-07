#!/bin/bash

wget -O- https://baltocdn.com/i3-window-manager/signing.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/i3wm-signing.gpg && \
sudo apt install apt-transport-https --yes && \
sudo apt update && \
sudo apt install feh fonts-font-awesome rofi pulseaudio-utils xbacklight alsa-tools clipit gcc git terminator locate pcmanfm acpi libnotify-bin htop
sudo add-apt-repository -y -u ppa:linuxuprising/shutter
sudo apt install shutter
sudo apt install i3 --yes
