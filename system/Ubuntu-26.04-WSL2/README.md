# Ubuntu-26.04-WSL2

The system half is small and needs no ansible: a few apt packages, zsh as the
login shell and `/etc/wsl.conf`. Nix is installed **single-user** with the
upstream script, so there is no nix-daemon to run, and `make switch` at the
repo root (home-manager from `home/`) takes over right after.

```bash
curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Ubuntu-26.04-WSL2/bootstrap.sh | bash
```

`bootstrap.sh` does, in order:

1. `apt-get install git curl make xz-utils ca-certificates zsh`
2. `chsh -s /usr/bin/zsh` if zsh is not the login shell yet
3. on WSL, if `/etc/wsl.conf` does not exist yet: `boot.systemd=true` (home-manager's
   user units), `interop.appendWindowsPath=false`, `user.default=$USER` -- then run
   `wsl --shutdown` from Windows once the script is done
4. `curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --no-daemon`
5. clone this repo into `~/Projects/dotfiles` (load-bearing path)
6. `make switch` (`nix run ./home#home-manager -- switch --flake ./home#ak -b hm-bak`)

`make wsl` from the repo root runs the same script; it is safe to re-run. Log out
and back in once afterwards for the session variables.
