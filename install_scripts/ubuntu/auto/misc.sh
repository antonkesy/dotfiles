#!/bin/bash

sudo apt install -y libreoffice

# Haskell Language Server specific version
export BOOTSTRAP_HASKELL_NONINTERACTIVE=1
source ~/.config/zsh/haskell.zsh
ghcup install ghc 8.10.3
ghcup compile hls --git-ref 1.4.0 --ghc 8.10.3
