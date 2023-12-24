#!/bin/bash

sudo apt install tmux fzf xsel exa fd-find atop btop
pip install trash-cli

# unbind alt to avoaid conflict with tmux
pip install libtmux
gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "[]" && \
gsettings set org.gnome.desktop.wm.keybindings switch-group "[]" && \
gsettings set org.gnome.desktop.wm.keybindings switch-group-backward "[]"


# Requires built_from_source/alacritty/install.sh
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $(which alacritty) 50
sudo update-alternatives --config x-terminal-emulator

pip install nautilus
sudo apt install python3-nautilus

# https://github.com/Stunkymonkey/nautilus-open-any-terminal
pip install nautilus-open-any-terminal
sudo glib-compile-schemas /usr/share/glib-2.0/schemas
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal keybindings '<Ctrl><Alt>t'
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal flatpak system
