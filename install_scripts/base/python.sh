#!/bin/bash

VERSION="3.12"

sudo apt install -y python3-pip pipx python${VERSION}-full python${VERSION}-dev
pipx install pre-commit
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.${VERSION} 1

pipx install jupyterlab notebook

# allows to install system pip instead of pipx
# sudo rm /usr/lib/python${VERSION}/EXTERNALLY-MANAGED -f
