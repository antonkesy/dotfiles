#!/bin/bash

# https://learn.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#supported-distributions
declare repo_version=$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"'; fi)
wget https://packages.microsoft.com/config/ubuntu/"$repo_version"/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo rm packages-microsoft-prod.deb
sudo apt update -y
# https://stackoverflow.com/questions/73312785/dotnet-sdk-is-installed-but-not-recognized-linux-ubuntu-popos-22-04
# clean install
sudo snap remove dotnet-sdk
sudo apt -y remove 'dotnet*'
sudo apt -y remove 'aspnetcore*'
sudo apt -y remove 'netstandard*'
sudo rm /etc/apt/sources.list.d/microsoft-prod.list
sudo rm /etc/apt/sources.list.d/microsoft-prod.list.save
sudo apt update -y
sudo apt install -y dotnet8
