#!/bin/bash

UBUNTU_VERSION=$(lsb_release -rs)

case "$UBUNTU_VERSION" in
    "20.04")
        VERSION="3.8"
        ;;
    "22.04")
        VERSION="3.10"
        ;;
    "24.04")
        VERSION="3.12"
        ;;
    *)
        echo "Unkown Ubuntu version: $UBUNTU_VERSION; Falling back to Python 3.12"
        VERSION="3.12"
        ;;
esac

echo "Using Python $VERSION for Ubuntu $UBUNTU_VERSION"

sudo apt install -y python3-pip pipx python${VERSION}-full python${VERSION}-dev
pipx install pre-commit
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${VERSION} 1

pipx install jupyterlab
pipx install notebook

# allows to install system pip instead of pipx
# sudo rm /usr/lib/python${VERSION}/EXTERNALLY-MANAGED -f
