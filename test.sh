#!/bin/bash

docker image rm dotfiles_test --force
docker build -t dotfiles_test .
docker run -it dotfiles_test
