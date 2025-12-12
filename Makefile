IN_DOCKER ?= 0
BECOME_FLAG := $(if $(filter 1,$(IN_DOCKER)),, --ask-become-pass)
TIMESTAMP := $(shell date +%Y%m%d_%H%M%S)

.PHONY: all base log desktop dotfiles install-ansible help test test-build dev-build dev test-dotfiles test-check test-base test-desktop clean galaxy unblock

all:
	echo "Select a target: dotfiles, base, desktop, test, clean"

galaxy:
	cd ansible && ansible-galaxy install -r requirements.yml

log:
	@mkdir -p ./log

dotfiles: galaxy log
	cd ansible && ansible-playbook site.yml --tags dotfiles 2>&1 | tee ../log/dotfiles_$(TIMESTAMP).log

base: galaxy log
	cd ansible && ansible-playbook $(BECOME_FLAG) site.yml --tags base 2>&1 | tee ../log/base_$(TIMESTAMP).log

desktop: galaxy log
	cd ansible && ansible-playbook $(BECOME_FLAG) site.yml 2>&1 | tee ../log/desktop_$(TIMESTAMP).log

check: galaxy log
	cd ansible && ansible-playbook $(BECOME_FLAG) site.yml --check 2>&1 | tee ../log/check_$(TIMESTAMP).log

dev-build:
	docker build -f ./docker/Arch.Dockerfile --target dev -t dotfiles-test-dev .

dev:
	@echo "Starting development container. Password: 'toor'"
	docker compose up -d dev
	docker compose exec dev bash

test: test-check test-dotfiles test-base test-desktop
	echo "All tests passed."

test-build:
	docker build -f ./docker/Arch.Dockerfile --target ci -t dotfiles-test .

test-check: test-build
	docker run --rm dotfiles-test bash -c "./prerequisites.sh && IN_DOCKER=1 make check"

test-base: test-build
	docker run --rm dotfiles-test bash -c "./prerequisites.sh && IN_DOCKER=1 make base"

test-desktop: test-build
	docker run --rm dotfiles-test bash -c "./prerequisites.sh && IN_DOCKER=1 make desktop"

test-dotfiles: test-build
	docker run --rm dotfiles-test bash -c "./prerequisites.sh && IN_DOCKER=1 make dotfiles"

dev-clean:
	@echo "Removing development container..."
	docker compose down -v

submodule-ssh:
	git config submodule.hyprland.url git@github.com:antonkesy/keypocalypse-now.git
	git config submodule.home/.config/lvim.url git@github.com:antonkesy/nvim-config.git
	git submodule sync
	git -C hyprland remote set-url origin git@github.com:antonkesy/keypocalypse-now.git
	git -C home/.config/lvim remote set-url origin git@github.com:antonkesy/nvim-config.git

clean:
	rm -rf ./build
	rm -rf ./.pytest_cache

unblock:
	sudo rm -f /var/lib/pacman/db.lck
