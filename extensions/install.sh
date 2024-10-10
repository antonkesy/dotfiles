#!/bin/bash

sudo apt-get install gnome-browser-connector
sudo apt install gnome-shell-extension-manager

# TODO: https://extensions.gnome.org/extension/4937/draw-on-you-screen-2

INSTALL_DIR=~/.local/share/gnome-shell/extensions/

# https://github.com/GnomeSnapExtensions/gSnap
ln -s ./gSnap ${INSTALL_DIR}/gSnap@micahosborne
gnome-extensions enable gSnap@micahosborne

# https://extensions.gnome.org/extension/779/clipboard-indicator/
ln -s ./gnome-shell-extension-lockkeys ${INSTALL_DIR}/clipboard-indicator@tudmotu.com
gnome-extensions enable clipboard-indicator@tudmotu.com

# https://extensions.gnome.org/extension/36/lock-keys/
ln -s ./gnome-shell-extension-lockkeys ${INSTALL_DIR}/lockkeys@vaina.lt
gnome-extensions enable lockkeys@vaina.lt
