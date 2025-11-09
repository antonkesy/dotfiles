#!/bin/bash
set -e
set -x

if [ "$1" = "Ubuntu" ]; then
	# Repositories
	sudo apt update -y
	sudo apt install -y software-properties-common
	sudo add-apt-repository -y universe
	sudo add-apt-repository -y multiverse
	sudo add-apt-repository -y restricted

	# C++ build tools
	sudo apt-get install -y google-mock googletest cppcheck libboost-all-dev valgrind libgtest-dev linux-tools-common linux-tools-generic bear meson
	# Clang
	sudo apt install -y build-essential clang clang-format clang-tidy clangd
	# Compile for Windows
	sudo apt-get install -y mingw-w64

	# https://brew.sh/
	sudo apt-get install -y build-essential procps curl file git
	/bin/bash -c "NONINTERACTIVE=1 $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# https://bazel.build/install/ubuntu
	sudo apt install -y apt-transport-https curl gnupg
	cd "$HOME" &&
		curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg &&
		sudo mv bazel-archive-keyring.gpg /usr/share/keyrings &&
		echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
	sudo apt update && sudo apt install -y bazel

	# Dart
	sudo apt update -y
	sudo apt install -y apt-transport-https gnupg curl
	sudo sh -c 'curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg'
	sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/dart.gpg] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main" > /etc/apt/sources.list.d/dart_stable.list'
	sudo apt update -y
	sudo apt install -y dart

	# Dotnet
	sudo add-apt-repository -y ppa:dotnet/backports
	sudo apt update -y
	sudo apt install -y dotnet8

	# https://flatpak.org/setup/Ubuntu
	sudo apt install -y flatpak
	sudo apt install -y gnome-software-plugin-flatpak
	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

	# Golang
	sudo apt install -y golang-go

	# https://www.haskell.org/ghcup/
	sudo apt install build-essential curl libffi-dev libffi8ubuntu1 libgmp-dev libgmp10 libncurses-dev -y
	curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 sh
	# https://docs.haskellstack.org/en/stable/install_and_upgrade/
	curl -sSL https://get.haskellstack.org/ | sudo sh
	export BOOTSTRAP_HASKELL_NONINTERACTIVE=1
	source ~/.config/zsh/haskell.zsh
	cabal update
	ghcup install hls 1.4.0
	ghcup install ghc --set recommended

	# Java
	sudo apt install -y maven openjdk-21-jdk unzip zip curl
	# SDK-man & gradle
	curl -s "https://get.sdkman.io" | bash
	source "${HOME}/.sdkman/bin/sdkman-init.sh" && sdk selfupdate force && sdk install gradle

	# Lua
	sudo apt-get install -y luarocks
	sudo luarocks install luacheck

	# Node
	sudo apt purge nodejs -y
	sudo apt autoremove -y
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	brew install fnm --skip-post-install
	fnm install v23.3.0

	# Python
	sudo apt install -y python3-pip pipx python3-full python3-dev
	pipx install pre-commit
	pipx install jupyterlab
	pipx install notebook
	# package manager https://github.com/astral-sh/uv
	pipx install uv
	# allows to install system pip instead of pipx
	# sudo rm /usr/lib/python${VERSION}/EXTERNALLY-MANAGED -f
	sudo apt install -y software-properties-common
	sudo add-apt-repository ppa:deadsnakes/ppa -y
	sudo apt install -y \
		python3.12-dev python3.12-venv \
		python3.11-dev python3.11-venv \
		python3.10-dev python3.10-venv python3.9-dev python3.9-venv \
		python3.8-dev python3.8-venv \
		python3.7-dev python3.7-venv

	# Rust
	sudo apt-get install -y rustup
	rustup default stable
	sudo rustup default stable

	sudo apt-get -y install libgit2-dev libcurl4-openssl-dev libssh-dev libssl-dev pkgconf
	cargo install cargo-update

	# zsh
	sudo apt install -y unzip wget curl hsh
	# hack font
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip
	sudo mkdir /usr/share/fonts/truetype/hack/ -p
	sudo unzip ./Hack.zip -d /usr/share/fonts/truetype/hack/
	fc-cache -f -v
	sudo apt install -y zsh
	# set zsh as default shell
	sudo chsh -s "$(which zsh)"
	# https://github.com/ohmyzsh/ohmyzsh
	export RUNZSH=no
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

	# development and daily use tools
	sudo apt-get install -y git ffmpeg pandoc pdfarranger curl qt6-base-dev ubuntu-restricted-extras build-essential snapd vim
	# disk format support
	sudo apt-get install -y exfat-fuse ntfs-3g

elif [ "$1" = "Arch" ]; then
	sudo pacman -Syu --needed

	# AUR helpers
	cd ./arch/AUR_helpers && make yay paru
	sudo pacman -S --noconfirm less

	# C++ build tools
	sudo pacman -S --noconfirm gmock gtest cppcheck boost valgrind perf bear meson
	sudo pacman -S --noconfirm base-devel
	# Clang
	sudo pacman -S --noconfirm base-devel clang
	# Compile for Windows
	sudo pacman -S --noconfirm --needed mingw-w64-gcc

	# https://brew.sh/
	sudo pacman -S --noconfirm base-devel procps-ng curl file git
	/bin/bash -c "NONINTERACTIVE=1 $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# https://bazel.build/install/ubuntu
	yay -S --noconfirm bazel

	# Dart
	sudo pacman -S --noconfirm --needed dart

	# Dotnet
	sudo pacman -S --noconfirm --needed dotnet-sdk

	# https://flatpak.org/setup/Arch
	sudo pacman -S --needed --noconfirm flatpak
	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

	# Golang
	sudo pacman -S --needed --noconfirm go

	# https://www.haskell.org/ghcup/
	sudo pacman -S --noconfirm --needed base-devel curl libffi gmp ncurses
	curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 sh
	# https://docs.haskellstack.org/en/stable/install_and_upgrade/
	curl -sSL https://get.haskellstack.org/ | sudo sh
	export BOOTSTRAP_HASKELL_NONINTERACTIVE=1
	source ~/.config/zsh/haskell.zsh
	cabal update
	ghcup install hls 1.4.0
	ghcup install ghc --set recommended

	# Java
	sudo pacman -S --noconfirm --needed maven jdk8-openjdk jdk21-openjdk unzip zip curl
	# SDK-man & gradle
	curl -s "https://get.sdkman.io" | bash
	source "${HOME}/.sdkman/bin/sdkman-init.sh" && sdk selfupdate force && sdk install gradle

	# Lua
	sudo pacman -S --noconfirm --needed luarocks
	sudo luarocks install luacheck

	# Node
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	brew install fnm --skip-post-install
	fnm install v23.3.0

	# Python
	sudo pacman -S --noconfirm --needed python python-pip python-pipx
	pipx ensurepath
	pipx install pre-commit
	pipx install jupyterlab
	pipx install notebook
	sudo pacman -S --noconfirm --needed \
		python python-virtualenv
	yay -S --noconfirm python38 python39 python310 python311 python312

	# Rust
	sudo pacman -S --noconfirm --needed rustup
	rustup default stable
	sudo rustup default stable
	sudo pacman -S --noconfirm --needed libgit2 libcurl-compat libssh2 openssl pkgconf
	cargo install cargo-update

	# zsh
	sudo pacman -S --noconfirm --needed unzip wget curl
	# hack font
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip
	sudo mkdir /usr/share/fonts/truetype/hack/ -p
	sudo unzip ./Hack.zip -d /usr/share/fonts/truetype/hack/
	fc-cache -f -v
	sudo pacman -S --noconfirm --needed zsh
	# set zsh as default shell # TODO: without sudo?
	sudo chsh -s /usr/bin/zsh
	# https://github.com/ohmyzsh/ohmyzsh
	export RUNZSH=no
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

	# development and daily use tools
	sudo pacman -S --noconfirm --needed git ffmpeg pandoc pdfarranger curl qt6-base base-devel vim
	# disk format support
	sudo pacman -S --noconfirm --needed exfat-utils ntfs-3g

else
	echo "error: expected 'Ubuntu' or 'Arch'" >&2
	exit 1
fi
