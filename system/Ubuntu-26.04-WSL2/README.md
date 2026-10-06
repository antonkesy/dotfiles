# Ubuntu-26.04-WSL2

`bootstrap.sh`: apt packages, zsh as login shell, `/etc/wsl.conf` (systemd on,
Windows PATH off), single-user nix, then `make home`, then writes the work git
identity (`anton.kesy@intel.com`, signing key
`2EB6591AC06F0A73C2A2C64B6FE635B16AD26C1C`) to `~/.config/git/local`, which
`home/modules/git.nix` includes on every machine if present. Re-runnable via
`make wsl`. Run `wsl --shutdown` once after the first run.

HandBrake build deps (apt, rustup, cargo-c) are installed too, for cross-compiling
to Windows: `scripts/mingw-w64-build x86_64`, then
`./configure --cross=x86_64-w64-mingw32 --launch-jobs=$(nproc) --launch`.

Docker engine (`docker.io`) is installed, the service enabled, and the user added to
the `docker` group so `docker` runs without sudo. Takes effect after the one-time
`wsl --shutdown` and a fresh login; compose/buildx/lazydocker come from
`home/modules/containers.nix`.
