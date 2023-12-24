#!/bin/bash

sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 &&
#rustup override set stable &&
#rustup update stable &&
cd alacritty && 
cargo build --release &&
chmod +x target/release/alacritty &&
sudo cp ./target/release/alacritty /usr/local/bin &&
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info &&
echo "Alacritty installed successfully."
cd ..
