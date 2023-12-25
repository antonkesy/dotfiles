#!/bin/bash

# https://learn.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#supported-distributions
declare repo_version=$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"'; fi)
wget https://packages.microsoft.com/config/ubuntu/$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
apt update -y
# https://stackoverflow.com/questions/73312785/dotnet-sdk-is-installed-but-not-recognized-linux-ubuntu-popos-22-04
# clean install
snap remove dotnet-sdk
apt remove 'dotnet*'
apt remove 'aspnetcore*'
apt remove 'netstandard*'
rm /etc/apt/sources.list.d/microsoft-prod.list
rm /etc/apt/sources.list.d/microsoft-prod.list.save
apt update -y
apt install -y dotnet6 dotnet7
