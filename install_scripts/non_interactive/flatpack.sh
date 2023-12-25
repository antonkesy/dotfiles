#!/bin/bash

# https://flatpak.org/setup/Ubuntu
apt install flatpak
apt install gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
