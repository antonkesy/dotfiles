.PHONY: all base desktop dotfiles install-ansible help test test-build test-shell clean

all: base

install-ansible:
	sudo pacman -Syu --noconfirm
	sudo pacman -S --noconfirm ansible

base: install-ansible
	cd ansible && ansible-playbook site.yml --tags base

desktop: install-ansible
	cd ansible && ansible-playbook site.yml

dotfiles:
	cd ansible && ansible-playbook site.yml --tags dotfiles

role:
	@echo "Usage: make role ROLE=<role-name>"
	@echo "Example: make role ROLE=neovim"
	cd ansible && ansible-playbook site.yml --tags $(ROLE)

check:
	cd ansible && ansible-playbook site.yml --check

tags:
	cd ansible && ansible-playbook site.yml --list-tags

test-build:
	docker build -f ./docker/Arch.Dockerfile -t dotfiles-test .

test-shell: test-build
	docker run -it --rm dotfiles-test bash

test: test-build
	docker run --rm dotfiles-test bash -c "cd ansible && ansible-playbook site.yml --tags base --skip-tags aur"

clean:
	rm -rf ./build
	rm -rf ./.pytest_cache
