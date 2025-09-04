#!/bin/bash

if [ -f /.dockerenv ] || [ "$IS_DOCKER_BUILD" = "true" ]; then
	echo "Skipping cuda installation in Docker container."
else
	VERSION=575

	export DEBIAN_FRONTEND=noninteractive

	sudo add-apt-repository ppa:graphics-drivers/ppa -y
	sudo apt update -y
	sudo apt upgrade -y
	sudo apt remove 'nvidia-*' -y
	sudo apt-get --fix-broken install nvidia-driver-${VERSION} nvidia-utils-${VERSION} nvidia-cuda-toolkit -y
	# only required for multiple GPUs
	sudo prime-select nvidia || echo "Error Okay; Only required for multiple GPUs; Not Docker"

	# Docker support
	curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey |
		sudo gpg --dearmor --yes -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg &&
		curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list |
		sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |
			tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
	sudo apt-get update
	sudo apt-get install -y nvidia-container-toolkit
	sudo nvidia-ctk runtime configure --runtime=docker
fi
