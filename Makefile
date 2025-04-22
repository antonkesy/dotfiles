.PHONY:
	install_base
	install_all_auto
	install_all
	demo
	test
	clean_test_docker
	test_build
	test_base
	test_all_auto

install_base:
	./link.sh
	${MAKE} -C ./install_scripts/base
	${MAKE} -C ./built_from_source/neovim
	${MAKE} -C ./built_from_source/alacritty

install_all_auto: install_base
	${MAKE} -C ./install_scripts/auto

install_all: install_all_auto
	${MAKE} -C ./install_scripts/manual

dev:
	docker build --build-arg USERNAME=$(whoami) --target dev -t dotfiles_dev .
	docker run -it --mount type=bind,source="$(PWD)",target=/home/ak/dotfiles dotfiles_dev

demo:
	@if [ -z "$$(docker images -q dotfiles_demo)" ]; then \
		echo "Image 'dotfiles_demo' not found. Building..."; \
		docker build --target demo -t dotfiles_demo .; \
	else \
		echo "Image 'dotfiles_demo' already exists. Skipping build."; \
	fi
	docker run -it --build-arg USERNAME=$(whoami) dotfiles_demo bash

test: test_base test_all_auto

clean_test_docker:
	docker image rm dotfiles_test --force

test_build:
	docker build --build-arg USERNAME=ak --target test -t dotfiles_test .

test_base: clean_test_docker test_build
	docker run dotfiles_test bash -c "cd /home/ak/dotfiles && make install_base"

test_all_auto: clean_test_docker test_build
	docker run dotfiles_test bash -c "cd /home/ak/dotfiles && make install_all_auto"
