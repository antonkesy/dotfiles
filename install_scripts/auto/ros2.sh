#!/bin/bash

# webots: https://cyberbotics.com/doc/guide/installation-procedure#installing-the-debian-package-with-the-advanced-packaging-tool-apt
sudo mkdir -p /etc/apt/keyrings
cd /etc/apt/keyrings && sudo wget -q https://cyberbotics.com/Cyberbotics.asc

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/Cyberbotics.asc] https://cyberbotics.com/debian binary-amd64/" | sudo tee /etc/apt/sources.list.d/Cyberbotics.list
sudo apt update -y

sudo apt install webots -y
