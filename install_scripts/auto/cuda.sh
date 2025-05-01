#!/bin/bash

if [ -f /.dockerenv ] || [ "$IS_DOCKER_BUILD" = "true" ]; then
    echo "Skipping cuda installation in Docker container."
else
  VERSION=535 # TODO: increase due to theme bug

  export DEBIAN_FRONTEND=noninteractive

  # working nvidia driver with 24.04.1 Ubuntu and Razer Core X Chroma
  sudo add-apt-repository ppa:graphics-drivers/ppa -y
  sudo apt update -y
  sudo apt upgrade -y
  sudo apt remove 'nvidia-*' -y
  sudo apt-get --fix-broken install nvidia-driver-${VERSION}-open nvidia-utils-${VERSION} nvidia-cuda-toolkit -y
  # only required for multiple GPUs
  sudo prime-select nvidia || echo "Error Okay; Only required for multiple GPUs; Not Docker"
fi
