#!/bin/bash

sudo apt install -y tmux fzf xsel fd-find atop btop

~/.tmux/plugins/tpm/bin/install_plugins

pipx install trash-cli 'trash-cli[completion]'
cmds=(trash-empty trash-list trash-restore trash-put trash)
for cmd in ${cmds[@]}; do
  $cmd --print-completion bash | sudo tee /usr/share/bash-completion/completions/"$cmd"
  $cmd --print-completion zsh | sudo tee /usr/share/zsh/site-functions/_"$cmd"
  $cmd --print-completion tcsh | sudo tee /etc/profile.d/"$cmd".completion.csh
done

cargo install exa

# unbind alt to avoaid conflict with tmux
pipx install libtmux
sudo gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "[]" && \
    gsettings set org.gnome.desktop.wm.keybindings switch-group "[]" && \
    gsettings set org.gnome.desktop.wm.keybindings switch-group-backward "[]"


# Requires built_from_source/alacritty/install.sh
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $(which alacritty) 50
sudo update-alternatives --set x-terminal-emulator

pipx install nautilus
sudo apt -y install python3-nautilus

# https://github.com/starship/starship
curl -sS https://starship.rs/install.sh | sh -s -- --yes
starship preset nerd-font-symbols -o ~/.config/starship.toml

# https://github.com/zdharma-continuum/zinit?tab=readme-ov-file#automatic
export ZINIT_INSTALL_SILENT=1
export ZINIT_INSTALL_NO_ANNEX_PROMPT=1
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)" <<< "n"

# https://github.com/atuinsh/atuin
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# TODO: this is a shell command -> not in zsh for building
# zcompile ~/.zshrc
