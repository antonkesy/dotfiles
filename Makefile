IN_DOCKER ?= 0
BECOME_FLAG := $(if $(filter 1,$(IN_DOCKER)),, --ask-become-pass)

.PHONY: all base desktop dotfiles install-ansible help test test-build test-shell test-dotfiles test-check test-base test-desktop clean galaxy

all:
	echo "Select a target: dotfiles, base, desktop, test, clean"

galaxy:
	cd ansible && ansible-galaxy install -r requirements.yml

dotfiles: galaxy
	cd ansible && ansible-playbook site.yml --tags dotfiles

base: galaxy
	cd ansible && ansible-playbook $(BECOME_FLAG) site.yml --tags base

desktop: galaxy
	cd ansible && ansible-playbook $(BECOME_FLAG) site.yml

check: galaxy
	cd ansible && ansible-playbook site.yml --check

test: test-check test-dotfiles test-base test-desktop
	echo "All tests passed."

test-build:
	docker build -f ./docker/Arch.Dockerfile -t dotfiles-test .

test-shell: test-build
	docker run -it --rm dotfiles-test bash

test-check: test-build
	docker run --rm dotfiles-test bash -c "./prerequisites.sh && IN_DOCKER=1 make check"

test-base: test-build
	docker run --rm dotfiles-test bash -c "./prerequisites.sh && IN_DOCKER=1 make base"

test-desktop: test-build
	docker run --rm dotfiles-test bash -c "./prerequisites.sh && IN_DOCKER=1 make desktop"

test-dotfiles: test-build
	docker run --rm dotfiles-test bash -c "./prerequisites.sh && IN_DOCKER=1 make dotfiles"

clean:
	rm -rf ./build
	rm -rf ./.pytest_cache
