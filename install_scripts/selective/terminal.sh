#!/bin/bash

sudo apt install tmux fzf xsel fd-find atop btop
pip install trash-cli
cargo install exa
sudo apt install nodejs
sudo npm install -g @angular/cli

# unbind alt to avoaid conflict with tmux
pip install libtmux
sudo gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "[]" && \
    gsettings set org.gnome.desktop.wm.keybindings switch-group "[]" && \
    gsettings set org.gnome.desktop.wm.keybindings switch-group-backward "[]"


# Requires built_from_source/alacritty/install.sh
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $(which alacritty) 50
sudo update-alternatives --config x-terminal-emulator

pip install nautilus
sudo apt install python3-nautilus

# https://github.com/starship/starship
curl -sS https://starship.rs/install.sh | sh
starship preset nerd-font-symbols -o ~/.config/starship.toml
