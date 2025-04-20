#!/bin/bash

sudo apt install -y maven openjdk-21-jdk unzip zip

# gradle
curl -s "https://get.sdkman.io" | bash
source "${HOME}/.sdkman/bin/sdkman-init.sh" && sdk selfupdate force && sdk install gradle
