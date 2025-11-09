.PHONY:
	ubuntu
	test
	dev
	demo
	clean_demo_docker
	test
	clean_test_docker
	test_build
	test_dev
	test_current
	test_all_auto
	test_ubuntu_24_04
	test_ubuntu_25_04
	test_ubuntu_versions
	clean

arch_base:
	./bootstrap.sh
	python3 ./setup/setup.py base

ubuntu_base:
	./bootstrap.sh
	python3 ./setup/setup.py base

ubuntu:
	${MAKE} -C ./distros/ubuntu/etc
	${MAKE} -C ./distros/ubuntu/extensions

UID:= $(id -u)
GID= $(id -g)

ubuntu_dev:
	docker build -f ./docker/Ubuntu --build-arg USERNAME=ak --build-arg HOST_UID=$(HOST_UID) --build-arg HOST_GID=$(HOST_GID) --target test -t dotfiles_dev_ubuntu .
	docker run -it --mount type=bind,source="$(PWD)",target=/home/ak/dotfiles dotfiles_dev_ubuntu

arch_dev:
	docker build -f ./docker/Arch --build-arg USERNAME=ak --build-arg HOST_UID=$(HOST_UID) --build-arg HOST_GID=$(HOST_GID) --target test -t dotfiles_dev_arch .
	docker run -it --mount type=bind,source="$(PWD)",target=/home/ak/dotfiles dotfiles_dev_arch

demo:
	@if [ -z "$$(docker images -q dotfiles_demo)" ]; then \
		echo "Image 'dotfiles_demo' not found. Building..."; \
		docker build -f ./docker/Ubuntu --target demo -t dotfiles_demo .; \
	else \
		echo "Image 'dotfiles_demo' already exists. Skipping build."; \
	fi
	docker run -it dotfiles_demo bash

clean_demo_docker:
	docker image rm dotfiles_demo --force

test: test_current test_all_auto

test_packages:
	pytest packages/test.py -vvv
	# pytest packages/test.py -k "git" -v

clean_test_docker:
	docker image rm dotfiles_test --force

test_build:
	docker build -f ./docker/Ubuntu --build-arg USERNAME=ak --target test -t dotfiles_test .

test_dev: test_build
	docker run -it dotfiles_test bash

test_current: clean_test_docker
	$(call test_ubuntu_version,24.04)

test_all_auto: clean_test_docker test_build
	docker run dotfiles_test bash -c "cd /home/ak/dotfiles && make ubuntu_base ubuntu_auto"

define test_ubuntu_version
	docker build -f ./docker/Ubuntu --build-arg BASE_IMAGE=ubuntu:$(1) --build-arg USERNAME=ak --target test -t dotfiles_test_ubuntu_$(1) .
	docker run dotfiles_test_ubuntu_$(1) bash -c "cd /home/ak/dotfiles && make ubuntu_base"
endef

test_ubuntu_24_04:
	$(call test_ubuntu_version,24.04)

test_ubuntu_25_04:
	$(call test_ubuntu_version,25.04)

test_ubuntu_versions: test_ubuntu_25_04 test_ubuntu_24_04

clean: clean_demo_docker clean_test_docker
