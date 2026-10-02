#!/bin/bash
# HandBrake build deps for cross-compiling to Windows (x86_64-w64-mingw32).
# https://handbrake.fr/docs/en/latest/developer/install-dependencies-ubuntu.html
# https://handbrake.fr/docs/en/latest/developer/build-windows.html
set -euo pipefail

sudo apt-get update
# base build deps
sudo apt-get install -y autoconf automake build-essential cmake git libass-dev \
	libbz2-dev libfontconfig-dev libfreetype-dev libfribidi-dev libharfbuzz-dev \
	libjansson-dev liblzma-dev libmp3lame-dev libnuma-dev libogg-dev libopus-dev \
	libsamplerate0-dev libspeex-dev libssl-dev libtheora-dev libtool libtool-bin \
	libturbojpeg0-dev libvorbis-dev libvpx-dev libx11-dev libx264-dev libxml2-dev \
	m4 make meson nasm ninja-build patch pkg-config zlib1g-dev
# host deps for scripts/mingw-w64-build
sudo apt-get install -y bison bzip2 curl flex g++ gcc gzip pax
# Dolby Vision (libdovi): rust + cargo-c + Windows GNU target
sudo apt-get install -y rustup
rustup toolchain install stable
rustup default stable
rustup target add x86_64-pc-windows-gnu
cargo install cargo-c

cat <<'EOF'
Done. In a HandBrake checkout:
  scripts/mingw-w64-build x86_64
  ./configure --cross=x86_64-w64-mingw32 --launch-jobs=$(nproc) --launch
EOF
