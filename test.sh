#!/bin/sh

sudo docker build --tag dotfiles-test --file test/dockerfile . &&
sudo docker run -dit dotfiles-test --attach

