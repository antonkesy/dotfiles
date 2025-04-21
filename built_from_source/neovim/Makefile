all: build

.PHONY: dependencies build

dependencies:
	sudo apt-get install -y ninja-build gettext cmake unzip curl cmake

build: dependencies
	cd neovim && \
  sudo rm .deps build -rf && \
  sudo make CMAKE_BUILD_TYPE=RelWithDebInfo && \
  sudo make install
