#!/bin/bash

sudo apt-get install -y gnome-browser-connector gnome-terminal gnome-shell-extension-manager

# TODO: https://extensions.gnome.org/extension/4937/draw-on-you-screen-2

INSTALL_DIR=~/.local/share/gnome-shell/extensions

# https://github.com/GnomeSnapExtensions/gSnap
cp -rf ./gSnap ${INSTALL_DIR}/gSnap@micahosborne
gnome-extensions enable gSnap@micahosborne

# https://extensions.gnome.org/extension/779/clipboard-indicator/
cp -rf ./gnome-shell-extension-clipboard-indicator ${INSTALL_DIR}/clipboard-indicator@tudmotu.com
gnome-extensions enable clipboard-indicator@tudmotu.com

# https://extensions.gnome.org/extension/36/lock-keys/
cp -rf ./gnome-shell-extension-lockkeys/lockkeys@vaina.lt/ ${INSTALL_DIR}/lockkeys@vaina.lt
gnome-extensions enable lockkeys@vaina.lt
