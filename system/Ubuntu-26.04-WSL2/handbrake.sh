#!/bin/bash
set -euo pipefail

sudo apt-get update

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
