#!/bin/bash

sudo apt-get install -y rustup
rustup default stable
sudo rustup default stable

sudo apt-get -y install libgit2-dev libcurl4-openssl-dev libssh-dev libssl-dev pkgconf
cargo install cargo-update
