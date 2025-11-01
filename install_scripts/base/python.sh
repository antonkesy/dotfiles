#!/bin/bash

UBUNTU_VERSION=$(lsb_release -rs)

case "$UBUNTU_VERSION" in
"22.04")
	VERSION="3.10"
	;;
"24.04")
	VERSION="3.12"
	;;
"25.04")
	VERSION="3.13"
	;;
*)
	echo "Unkown Ubuntu version: $UBUNTU_VERSION; Falling back to Python 3.12"
	VERSION="3.12"
	;;
esac

echo "Using Python $VERSION for Ubuntu $UBUNTU_VERSION"

# install full python for current ubuntu version
sudo apt install -y python3-pip pipx python${VERSION}-full python${VERSION}-dev
pipx install pre-commit

pipx install jupyterlab
pipx install notebook

# package manager https://github.com/astral-sh/uv
pipx install uv
# allows to install system pip instead of pipx
# sudo rm /usr/lib/python${VERSION}/EXTERNALLY-MANAGED -f

# install other python versions for development and venv support
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt install -y \
	python3.12-dev python3.12-venv \
	python3.11-dev python3.11-venv \
	python3.10-dev python3.10-venv python3.9-dev python3.9-venv \
	python3.8-dev python3.8-venv \
	python3.7-dev python3.7-venv
