.PHONY: all base desktop dotfiles install-ansible help test test-build test-shell test-dotfiles test-base test-desktop clean

all: base

install-ansible:
	sudo pacman -Syu --noconfirm
	sudo pacman -S --noconfirm ansible

dotfiles:
	cd ansible && ansible-playbook site.yml --tags dotfiles -v

base: install-ansible
	cd ansible && ansible-playbook site.yml --tags base -v

desktop: install-ansible
	cd ansible && ansible-playbook site.yml -v

check:
	cd ansible && ansible-playbook site.yml --check -v

test: test-dotfiles test-base test-desktop
	echo "All tests passed."

test-build:
	docker build -f ./docker/Arch.Dockerfile -t dotfiles-test .

test-shell: test-build
	docker run -it --rm dotfiles-test bash

test-dotfiles: test-build
	docker run --rm dotfiles-test bash -c "make dotfiles"

test-base: test-build
	docker run --rm dotfiles-test bash -c "make base"

test-desktop: test-build
	docker run --rm dotfiles-test bash -c "make desktop"

clean:
	rm -rf ./build
	rm -rf ./.pytest_cache
