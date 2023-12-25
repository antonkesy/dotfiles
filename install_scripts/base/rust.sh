#!/bin/bash

# https://www.rust-lang.org/tools/install
apt install -y curl && \
curl https://sh.rustup.rs -sSf | sh -s -- -y
# Add cargo to path!
