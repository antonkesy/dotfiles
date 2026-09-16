# Arch

Ansible for what home-manager cannot do: pacman/AUR packages, systemd, PAM. The
`nix` role runs last and applies `home/`.

| target       | what it does                              |
| ------------ | ----------------------------------------- |
| `make arch`  | apply the playbook                        |
| `make dry`   | `--check --diff`                          |
| `make lint`  | ansible-lint                              |
| `make test`  | `make dry` inside the Arch container      |
| `make dev`   | shell in that container, repo bind-mounted |
| `make clean` | remove `./build` (AUR builds)             |

Roles, in order: `base`, `desktop`, `nvidia`, `laptop`, `containers`, `nix`.
Every role runs on every machine; `is_container` skips services and PAM.

```
archinstall.json     phase 1, on the live ISO
bootstrap.sh         phase 2, after the first login
ansible/             site.yml + roles
docker/              image for make test / dev
hyprpm.sh            Hyprland plugins, run by make arch after the playbook
```
