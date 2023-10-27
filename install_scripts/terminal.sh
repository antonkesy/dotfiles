#!/bin/bash

sudo apt install tmux fzf xsel exa fd-find atop btop
pip install trash-cli

# unbind alt to avoaid conflict with tmux
gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-group "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-group-backward "[]"

# Requires built_from_source/alacritty/install.sh
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $(which alacritty) 50
sudo update-alternatives --config x-terminal-emulator

pip install nautilus
