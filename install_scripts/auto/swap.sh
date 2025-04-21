#!/bin/bash

SWAP_FILE=/swapfile

sudo fallocate -l 100G "$SWAP_FILE"
sudo chmod 600 "$SWAP_FILE"
sudo mkswap "$SWAP_FILE"
sudo swapon "$SWAP_FILE"
echo "$SWAP_FILE none swap sw 0 0" | sudo tee -a /etc/fstab
sudo swapon --show
