#!/bin/bash

sudo apt install -y maven openjdk-11-jdk-headless openjdk-11-jdk openjdk-11-jre-headless openjdk-11-jre openjdk-17-jdk-headless openjdk-17-jre-headless openjdk-18-jdk-headless openjdk-18-jdk openjdk-18-jre-headless openjdk-18-jre openjdk-8-jdk-headless openjdk-8-jre-headless
# TODO set to java 18

# gradle
curl -s "https://get.sdkman.io" | bash
sdk selfupdate force
source "${HOME}/.sdkman/bin/sdkman-init.sh"
sdk install gradle

