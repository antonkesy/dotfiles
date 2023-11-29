#!/bin/bash

# https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html
# locale  # check for UTF-8

# sudo apt update && sudo apt install locales
# sudo locale-gen en_US en_US.UTF-8
# sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
# export LANG=en_US.UTF-8

# sudo apt install software-properties-common
# sudo add-apt-repository universe
# sudo apt update && sudo apt install curl -y
# sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
# echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
# sudo apt update
# sudo apt install ros-humble-desktop ros-dev-tools ros-humble-ros-base -y

# nomachine
wget https://download.nomachine.com/download/8.6/Linux/nomachine_8.6.1_3_amd64.deb
sudo apt install ./nomachine*
rm ./nomachine*

# webots 
# https://cyberbotics.com/doc/guide/installation-procedure#installing-the-debian-package-with-the-advanced-packaging-tool-apt
wget -qO- https://cyberbotics.com/Cyberbotics.asc | sudo apt-key add -
sudo apt-add-repository 'deb https://cyberbotics.com/debian/ binary-amd64/'
sudo apt-get update
sudo apt-get install webots -y
