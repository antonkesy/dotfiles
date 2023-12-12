#!/bin/bash

# https://www.rust-lang.org/tools/install
sudo apt install curl && \
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path --profile=default
# Add cargo to path!
