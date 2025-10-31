#!/bin/bash

sudo apt update
sudo apt install -y apt-transport-https gnupg curl

sudo sh -c 'curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg'
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/dart.gpg] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main" > /etc/apt/sources.list.d/dart_stable.list'

sudo apt update
sudo apt install -y dart

dart --version
