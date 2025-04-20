#!/bin/bash


SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source ~/.config/zsh/rust.zsh

sudo apt install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
cd "${SCRIPT_DIR}"/alacritty &&
cargo build --release &&
chmod +x target/release/alacritty &&
sudo cp ./target/release/alacritty /usr/local/bin &&
tic -xe alacritty,alacritty-direct extra/alacritty.info &&
echo "Alacritty installed successfully."
cd ..
