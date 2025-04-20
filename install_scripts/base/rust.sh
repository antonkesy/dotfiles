#!/bin/bash

# https://www.rust-lang.org/tools/install
sudo apt install -y curl && \
curl https://sh.rustup.rs -sSf | sh -s -- -y
# Add cargo to path!

sudo apt-get -y install libgit2-dev libcurl4-openssl-dev libssh-dev libssl-dev pkgconf
export PATH="$HOME/.cargo/bin:$PATH" && cargo install cargo-update
