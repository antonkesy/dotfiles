desktop:
	./bootstrap.sh
	python3 ./setup/setup.py desktop

base:
	./bootstrap.sh
	python3 ./setup/setup.py base

## Testing and Development targets
UID:= $(id -u)
GID= $(id -g)

arch_dev:
	docker build -f ./docker/Arch.Dockerfile --build-arg USERNAME=ak --build-arg HOST_UID=$(HOST_UID) --build-arg HOST_GID=$(HOST_GID) --target test -t dotfiles_dev_arch .
	docker run -it --mount type=bind,source="$(PWD)",target=/home/ak/dotfiles dotfiles_dev_arch

test: test_current test_all_auto

test_packages:
	pipx install pytest
	pytest ./test/packages.py -vvv
	# pytest ./test/packages.py -k "git" -v

clean_test_docker:
	docker image rm dotfiles_test --force

test_build:
	docker build -f ./docker/Arch.Dockerfile --build-arg USERNAME=ak --target test -t dotfiles_test .

test_dev: test_build
	docker run -it dotfiles_test bash

test_all_auto: clean_test_docker test_build
	docker run dotfiles_test bash -c "cd /home/ak/dotfiles && make ubuntu_base ubuntu_auto"

clean: clean_test_docker

.PHONY:
	test
	dev
	test
	clean_test_docker
	test_build
	test_dev
	test_current
	test_all_auto
	clean
