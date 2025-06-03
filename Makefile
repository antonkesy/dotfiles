.PHONY:
	install_base
	install_all_auto
	install_all
	dev
	demo
	clean_demo_docker
	test
	clean_test_docker
	test_build
	test_dev
	test_current
	test_all_auto
	test_ubuntu_20_04
	test_ubuntu_22_04
	test_ubuntu_24_04
	test_ubuntu_versions
	clean

install_base:
	./link.sh
	${MAKE} -C ./install_scripts/base
	${MAKE} -C ./built_from_source/neovim
	${MAKE} -C ./built_from_source/alacritty

install_all_auto: install_base
	${MAKE} -C ./install_scripts/auto

install_all: install_all_auto
	${MAKE} -C ./install_scripts/manual

install_after_reboot:
	${MAKE} -C ./install_scripts/after_reboot

install_device_specific:
	${MAKE} -C ./install_scripts/auto device_specific

ubuntu:
	${MAKE} -C ./ubuntu/etc
	${MAKE} -C ./ubuntu/extensions

dev:
	docker build --build-arg USERNAME=ak --target dev -t dotfiles_dev .
	docker run -it --mount type=bind,source="$(PWD)",target=/home/ak/dotfiles dotfiles_dev

demo:
	@if [ -z "$$(docker images -q dotfiles_demo)" ]; then \
		echo "Image 'dotfiles_demo' not found. Building..."; \
		docker build --target demo -t dotfiles_demo .; \
	else \
		echo "Image 'dotfiles_demo' already exists. Skipping build."; \
	fi
	docker run -it dotfiles_demo bash

clean_demo_docker:
	docker image rm dotfiles_demo --force

test: test_current test_all_auto

clean_test_docker:
	docker image rm dotfiles_test --force

test_build:
	docker build --build-arg USERNAME=ak --target test -t dotfiles_test .

test_dev: test_build
	docker run -it dotfiles_test bash

test_current: clean_test_docker
	$(call test_ubuntu_version,24.04)

test_all_auto: clean_test_docker test_build
	docker run dotfiles_test bash -c "cd /home/ak/dotfiles && make install_all_auto"

define test_ubuntu_version
	docker build --build-arg BASE_IMAGE=ubuntu:$(1) --build-arg USERNAME=ak --target test -t dotfiles_test_ubuntu_$(1) .
	docker run dotfiles_test_ubuntu_$(1) bash -c "cd /home/ak/dotfiles && make install_base"
endef

test_ubuntu_20_04:
	$(call test_ubuntu_version,20.04)

test_ubuntu_22_04:
	$(call test_ubuntu_version,22.04)

test_ubuntu_24_04:
	$(call test_ubuntu_version,24.04)

test_ubuntu_versions: test_ubuntu_24_04 test_ubuntu_20_04 test_ubuntu_22_04

clean: clean_demo_docker clean_test_docker
