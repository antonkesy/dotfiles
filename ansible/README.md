# Dotfiles (Ansible)

Arch Linux dotfiles and system setup using Ansible.

## Quick Start

```bash
# Bootstrap (installs ansible and runs base setup)
make

# Or full desktop setup
make desktop
```

## Usage

```bash
# Install only base packages
make base

# Install full desktop environment
make desktop

# Only link dotfiles
make dotfiles

# Run specific role
make role ROLE=neovim
make role ROLE=python

# Dry run (check mode)
make check

# List available tags
make tags
```

## Structure

```
ansible/
├── ansible.cfg          # Ansible configuration
├── inventory            # Localhost inventory
├── site.yml             # Main playbook
├── Makefile             # Easy commands
└── roles/
    ├── dotfiles/        # Symlink dotfiles
    ├── aur-helpers/     # paru, yay
    ├── base-packages/   # Core packages
    ├── zsh/             # Zsh shell
    ├── git/             # Git config
    ├── dev-tools/       # Development tools
    ├── python/          # Python + pipx
    ├── node/            # Node.js
    ├── rust/            # Rust via rustup
    ├── golang/          # Go
    ├── neovim/          # Build neovim from source
    └── desktop/         # GNOME + Hyprland
```

## Adding New Packages

### 1. Add to existing role

Edit `roles/<role>/tasks/main.yml` or `roles/<role>/defaults/main.yml`

### 2. Create new role

```bash
mkdir -p ansible/roles/mypackage/tasks
```

Create `ansible/roles/mypackage/tasks/main.yml`:

```yaml
---
- name: Install mypackage
  become: true
  pacman:
    name: mypackage
    state: present
```

Add to `site.yml`:

```yaml
- { role: mypackage, tags: ["base", "mypackage"] }
```

### 3. AUR packages

```yaml
- name: Install AUR package
  command: "yay -S --noconfirm --needed mypackage"
  changed_when: false
```

## Tags

- `base` - Core setup
- `desktop` - Full desktop environment
- `dotfiles` - Only dotfile linking
- `lang` - Programming languages
- Individual role names (python, node, neovim, etc.)

## Variables

Override variables in `ansible/group_vars/all.yml` or via command line:

```bash
ansible-playbook site.yml -e "git_user_name='Your Name'"
```
