.PHONY: all base desktop dotfiles install-ansible help test test-build test-shell

# Default target
all: base

# Install ansible (bootstrap)
install-ansible:
	sudo pacman -Syu --noconfirm
	sudo pacman -S --noconfirm ansible

# Run full base setup
base: install-ansible
	cd ansible && ansible-playbook site.yml --tags base

# Run desktop setup (includes base)
desktop: install-ansible
	cd ansible && ansible-playbook site.yml

# Only link dotfiles
dotfiles:
	cd ansible && ansible-playbook site.yml --tags dotfiles

# Run specific role
role:
	@echo "Usage: make role ROLE=<role-name>"
	@echo "Example: make role ROLE=neovim"
	cd ansible && ansible-playbook site.yml --tags $(ROLE)

# Check mode (dry run)
check:
	cd ansible && ansible-playbook site.yml --check

# List all available tags
tags:
	cd ansible && ansible-playbook site.yml --list-tags

# Docker testing
test-build:
	docker build -f ../docker/Arch.Dockerfile -t dotfiles-test ..

test-shell: test-build
	docker run -it --rm dotfiles-test bash

test: test-build
	docker run --rm dotfiles-test bash -c "cd ansible && ansible-playbook site.yml --tags base --skip-tags aur"

help:
	@echo "Available targets:"
	@echo "  all          - Run base setup (default)"
	@echo "  base         - Install base packages and setup"
	@echo "  desktop      - Full desktop setup"
	@echo "  dotfiles     - Only link dotfiles"
	@echo "  role ROLE=x  - Run specific role"
	@echo "  check        - Dry run"
	@echo "  tags         - List available tags"
	@echo ""
	@echo "Testing:"
	@echo "  test         - Run ansible in Docker"
	@echo "  test-build   - Build test Docker image"
	@echo "  test-shell   - Open shell in Docker container"
