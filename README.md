# Dotfiles

Arch Linux dotfiles and system setup using Ansible.

## Fresh Arch Install

```bash
curl https://github.com/antonkesy/dotfiles/blob/main/arch_install_config.json
# setup all missing parts like partitioning, users, etc.
archinstall --config arch_install_config.json
mkdir -p ~/workspace && cd ~/workspace
git clone https://github.com/antonkesy/dotfiles.git
make desktop
```

## Currently Used With

- Arch Linux
- Nvidia RTX 4070
- [tmux](https://github.com/tmux/tmux/wiki) + [zsh](https://ohmyz.sh/)
- [LunarVim](https://www.lunarvim.org/)
- [Spacemacs](https://www.spacemacs.org/)

## Workarounds

### Gnome Online Accounts on Hyprland

- Just login through Gnome session :)
