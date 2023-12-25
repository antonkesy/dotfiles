#!/bin/bash

# https://flatpak.org/setup/Ubuntu
apt install -y flatpak
apt install -y gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
