#!/bin/bash

# https://www.haskell.org/ghcup/
sudo apt install build-essential curl libffi-dev libffi8ubuntu1 libgmp-dev libgmp10 libncurses-dev -y
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

# https://docs.haskellstack.org/en/stable/install_and_upgrade/
curl -sSL https://get.haskellstack.org/ | sudo sh


# install specific HLS version for specific GHC version
ghcup compile hls --git-ref 1.4.0 --ghc 8.10.3
