REPO_ROOT := $(abspath ../..)
ANSIBLE := ansible
PLAYBOOK := cd $(ANSIBLE) && ansible-playbook site.yml
BECOME_FLAG := $(if $(filter 1,$(IN_DOCKER)),,--ask-become-pass)

.PHONY: help galaxy arch ansible-check ansible-syntax lint test-arch dev-arch clean

help:
	@echo "Arch system half via ansible; the nix role ends in home-manager switch from the repo root:"
	@echo "  arch           - the playbook: every role, host ak"
	@echo "  ansible-check  - dry run of the playbook on this machine"
	@echo "  ansible-syntax - syntax-check the playbook"
	@echo "  lint           - ansible-lint"
	@echo "  test-arch      - ansible --check inside the Arch container"
	@echo "  dev-arch       - shell in the Arch container, repo bind-mounted at ~/Projects/dotfiles"
	@echo "  clean          - remove ./build (AUR builds)"
	@echo "Fresh install: ./install.sh on the live ISO, then bootstrap.sh after the reboot"

galaxy:
	cd $(ANSIBLE) && ansible-galaxy collection install -r requirements.yml

arch: galaxy
	$(PLAYBOOK) $(BECOME_FLAG)

ansible-check: galaxy
	$(PLAYBOOK) $(BECOME_FLAG) --check --diff

ansible-syntax:
	cd $(ANSIBLE) && ansible-playbook site.yml --syntax-check

lint:
	cd $(ANSIBLE) && ansible-lint

# Build context is the repo root (trimmed by /.dockerignore): the image copies
# it to ~/Projects/dotfiles and runs the root Makefile, which dispatches here.
test-arch:
	docker build -f docker/Arch.Dockerfile --target ci -t dotfiles-test-arch $(REPO_ROOT)
	docker run --rm dotfiles-test-arch make galaxy ansible-check IN_DOCKER=1

dev-arch:
	docker build -f docker/Arch.Dockerfile --target dev -t dotfiles-dev-arch $(REPO_ROOT)
	docker run --rm -it -v $(REPO_ROOT):/home/ak/Projects/dotfiles dotfiles-dev-arch bash

# AUR builds (roles/aur_build, build_dir = playbook_dir/../build) land here.
clean:
	rm -rf build
