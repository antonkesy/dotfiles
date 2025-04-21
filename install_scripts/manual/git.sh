#!/bin/bash

sudo apt-get install git-lfs -y

git config --global user.name "Anton Kesy" &&
git config --global user.email "antonkesy@gmail.com" &&
git config --global core.editor lvim &&
git config --global init.defaultBranch main &&
git config --global help.autocorrect 10 &&
git config --global bash.showDirtyState true &&
git config --global bash.showUntrackedFiles true &&
git config --global pull.rebase true

git config --global commit.gpgsign true
gpg --list-secret-keys --keyid-format=long
echo "type: 'git config --global user.signingkey KEYID'"
