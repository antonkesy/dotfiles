#!/bin/bash

apt install -y maven openjdk-21-jdk 
# sudo update-alternatives --install /usr/bin/java java /path/to/java 1
# sudo update-alternatives --config java

# gradle
curl -s "https://get.sdkman.io" | bash
source "${HOME}/.sdkman/bin/sdkman-init.sh"
sdk selfupdate force
sdk install gradle

