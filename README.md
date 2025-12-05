# Dotfiles

Arch Linux dotfiles and system setup using Ansible.

## Fresh Arch Install

- Ensure `sudo` is available for the user
  - `pacman -S --noconfirm --needed sudo` as `root`/`su`

```bash
iwctl station <your_wifi_device> connect <your_wifi_ssid>
curl -L https://raw.githubusercontent.com/antonkesy/dotfiles/main/arch_install_config.json -o arch_install_config.json
# setup all missing parts like partitioning, users, etc.
archinstall --config arch_install_config.json

# Reboot and login into new user
nmcli radio wifi on
nmcli device wifi list
nmcli device wifi connect "<SSID>" password "<PASSWORD>"

# some setups might assume position of dotfiles in ~/workspace
mkdir -p ~/workspace && cd ~/workspace
sudo pacman -S --noconfirm --needed git
git clone --recursive https://github.com/antonkesy/dotfiles.git
./prerequisites.sh
make desktop
```

## Targets

- `make dotfiles` - Links only dotfiles
- `make base` - Minimal setup (for example for WSL)
- `make desktop` - Full desktop setup

## Currently Used With

- Arch Linux
- Nvidia RTX 4070
- [tmux](https://github.com/tmux/tmux/wiki) + [zsh](https://ohmyz.sh/)
- [LunarVim](https://www.lunarvim.org/)
- [Spacemacs](https://www.spacemacs.org/)

## Workarounds

### Gnome Online Accounts on Hyprland

- Just login through Gnome session :)

## Tests

```bash
make test
```
