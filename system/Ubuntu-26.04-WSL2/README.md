# Ubuntu-26.04-WSL2

`bootstrap.sh`: apt packages, zsh as login shell, `/etc/wsl.conf` (systemd on,
Windows PATH off), single-user nix, then `make home`, then writes the work git
identity (`anton.kesy@intel.com`) to `~/.config/git/local`, which
`home/modules/git.nix` includes on every machine if present. Re-runnable via
`make wsl`. Run `wsl --shutdown` once after the first run.

HandBrake build deps (apt, rustup, cargo-c) are installed too, for cross-compiling
to Windows: `scripts/mingw-w64-build x86_64`, then
`./configure --cross=x86_64-w64-mingw32 --launch-jobs=$(nproc) --launch`.
