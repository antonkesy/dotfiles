#!/bin/bash

# https://www.haskell.org/ghcup/
apt install build-essential curl libffi-dev libffi8ubuntu1 libgmp-dev libgmp10 libncurses-dev -y
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

# https://docs.haskellstack.org/en/stable/install_and_upgrade/
curl -sSL https://get.haskellstack.org/ | sh
