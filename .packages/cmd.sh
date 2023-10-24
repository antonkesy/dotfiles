#!/bin/bash

sudo apt install tmux fzf xsel
pip install trash-cli

# unbind alt to avoaid conflict with tmux
gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-group "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-group-backward "[]"
