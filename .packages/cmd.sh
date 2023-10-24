#!/bin/bash

sudo apt install tmux fzf
pip install trash-cli

# unbind alt to avoaid conflict with tmux
gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "[]"
