#!/bin/bash

# https://www.haskell.org/ghcup/
sudo apt install build-essential curl libffi-dev libffi8ubuntu1 libgmp-dev libgmp10 libncurses-dev -y
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 sh

# https://docs.haskellstack.org/en/stable/install_and_upgrade/
curl -sSL https://get.haskellstack.org/ | sudo sh

export BOOTSTRAP_HASKELL_NONINTERACTIVE=1
source ~/.config/zsh/haskell.zsh
cabal update
ghcup install hls 1.4.0
ghcup install ghc --set recommended
