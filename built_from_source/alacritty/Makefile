all: build

.PHONY: dependencies build

# https://github.com/alacritty/alacritty/blob/master/INSTALL.md#debianubuntu
dependencies:
	sudo apt install -y cmake g++ pkg-config libfreetype-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

build: dependencies
	cd alacritty && \
	sudo rm -rf target && \
	cargo build --release && \
	chmod +x ./target/release/alacritty && \
	sudo cp ./target/release/alacritty /usr/local/bin && \
	tic -xe alacritty,alacritty-direct extra/alacritty.info
