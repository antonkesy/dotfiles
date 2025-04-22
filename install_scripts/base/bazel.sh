#!/bin/bash

# https://bazel.build/install/ubuntu
sudo apt install -y apt-transport-https curl gnupg
cd "$HOME" && \
curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg  && \
sudo mv bazel-archive-keyring.gpg /usr/share/keyrings  && \
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list

sudo apt update && sudo apt install -y bazel
