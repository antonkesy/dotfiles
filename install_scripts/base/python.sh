#!/bin/bash

VERSION="3.12"

sudo rm /usr/lib/python${VERSION}/EXTERNALLY-MANAGED -f
sudo apt install -y python3-pip pipx python${VERSION}-full python${VERSION}-dev
pip install pre-commit
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.${VERSION} 1

pip install jupyterlab notebook
