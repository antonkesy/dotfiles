#!/bin/bash

if [ -f /.dockerenv ] || [ "$IS_DOCKER_BUILD" = "true" ]; then
    echo "Skipping Docker installation in Docker container."
else
  # https://docs.docker.com/engine/install/ubuntu/
  sudo apt-get -y update
  sudo apt-get -y install ca-certificates curl gnupg

  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update -y

  sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  # post install
  sudo groupadd docker
  sudo usermod -aG docker "$USER"
  sudo newgrp docker
fi
