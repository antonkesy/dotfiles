#!/bin/bash
# curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Ubuntu-26.04-WSL2/bootstrap.sh | bash
set -euo pipefail

PROJECTS="${PROJECTS:-$HOME/Projects}"
DOTFILES="$PROJECTS/dotfiles"
ME="$(id -un)"

sudo apt-get update
sudo apt-get install -y git curl make xz-utils ca-certificates zsh

if [ "$(getent passwd "$ME" | cut -d: -f7)" != "/usr/bin/zsh" ]; then
	sudo chsh -s /usr/bin/zsh "$ME"
fi

if grep -qi microsoft /proc/version 2>/dev/null && [ ! -e /etc/wsl.conf ]; then
	printf '[boot]\nsystemd=true\n\n[interop]\nappendWindowsPath=false\n\n[user]\ndefault=%s\n' "$ME" |
		sudo tee /etc/wsl.conf >/dev/null
	echo "wrote /etc/wsl.conf: run 'wsl --shutdown' from Windows after this script finishes."
fi

if [ ! -x "$HOME/.nix-profile/bin/nix" ]; then
	curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --no-daemon
fi
# shellcheck disable=SC1091
. "$HOME/.nix-profile/etc/profile.d/nix.sh"

mkdir -p "$PROJECTS"
[ -d "$DOTFILES" ] || git clone --recursive https://github.com/antonkesy/dotfiles.git "$DOTFILES"
git -C "$DOTFILES" submodule update --init --recursive

# HandBrake native Linux build + cross-compile to Windows (x86_64-w64-mingw32)
# https://handbrake.fr/docs/en/latest/developer/install-dependencies-ubuntu.html
# https://handbrake.fr/docs/en/latest/developer/build-linux.html
# https://handbrake.fr/docs/en/latest/developer/build-windows.html
# clang/llvm: NVDEC (ffmpeg --enable-cuda-llvm); NVENC headers come from contrib/nvenc
sudo apt-get install -y autoconf automake build-essential cmake git libass-dev \
	libbz2-dev libfontconfig-dev libfreetype-dev libfribidi-dev libharfbuzz-dev \
	libjansson-dev liblzma-dev libmp3lame-dev libnuma-dev libogg-dev libopus-dev \
	libsamplerate0-dev libspeex-dev libssl-dev libtheora-dev libtool libtool-bin \
	libturbojpeg0-dev libvorbis-dev libvpx-dev libx11-dev libx264-dev libxml2-dev \
	m4 make meson nasm ninja-build patch pkg-config zlib1g-dev \
	bison bzip2 curl flex g++ gcc gzip pax rustup
# native Linux extras: Intel QSV/VAAPI, NVENC/NVDEC, GTK GUI
sudo apt-get install -y libva-dev libdrm-dev clang llvm \
	appstream desktop-file-utils gettext gstreamer1.0-libav \
	gstreamer1.0-plugins-good libgstreamer-plugins-base1.0-dev libgtk-4-dev
rustup toolchain install stable
rustup default stable
rustup target add x86_64-pc-windows-gnu
cargo install cargo-c

# Docker engine; compose/buildx/lazydocker come from home/modules/containers.nix
sudo apt-get install -y docker.io
getent group docker >/dev/null || sudo groupadd docker
id -nG "$ME" | grep -qw docker || sudo usermod -aG docker "$ME"
# systemd is PID 1 only after the first wsl --shutdown; apt enables the unit anyway
if [ -d /run/systemd/system ]; then
	sudo systemctl enable --now docker
fi

cd "$DOTFILES"
make home

GIT_LOCAL="${XDG_CONFIG_HOME:-$HOME/.config}/git/local"
if [ ! -e "$GIT_LOCAL" ]; then
	mkdir -p "$(dirname "$GIT_LOCAL")"
	cat >"$GIT_LOCAL" <<'EOC'
[user]
	email = anton.kesy@intel.com
	signingkey = 2EB6591AC06F0A73C2A2C64B6FE635B16AD26C1C
EOC
	echo "wrote $GIT_LOCAL"
fi

echo "Done. Log out and back in once (docker group takes effect in a new session)."
