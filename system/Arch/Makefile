REPO_ROOT := $(abspath ../..)
# ansible-galaxy first: the play needs community.general.
PLAYBOOK := cd ansible && ansible-galaxy collection install -r requirements.yml && ansible-playbook site.yml
BECOME_FLAG := $(if $(filter 1,$(IN_DOCKER)),,--ask-become-pass)

.PHONY: help arch dry lint test dev clean

help:
	@echo "Arch system half via ansible (every role, host ak); ends in home-manager switch from <repo>/home:"
	@echo "  arch   - apply the playbook"
	@echo "  dry    - ansible --check --diff on this machine"
	@echo "  lint   - ansible-lint"
	@echo "  test   - dry, inside the Arch container (docker)"
	@echo "  dev    - shell in that container, repo bind-mounted at ~/Projects/dotfiles"
	@echo "  clean  - remove ./build (AUR builds)"
	@echo "Fresh install: install.sh on the live ISO, bootstrap.sh after the reboot"

arch:
	$(PLAYBOOK) $(BECOME_FLAG)

dry:
	$(PLAYBOOK) $(BECOME_FLAG) --check --diff

lint:
	cd ansible && ansible-lint

# Build context is the repo root; the image copies it to ~/Projects/dotfiles.
test:
	docker build -f docker/Arch.Dockerfile --target ci -t dotfiles-test-arch $(REPO_ROOT)
	docker run --rm dotfiles-test-arch make -C system/Arch dry IN_DOCKER=1

dev:
	docker build -f docker/Arch.Dockerfile --target dev -t dotfiles-dev-arch $(REPO_ROOT)
	docker run --rm -it -v $(REPO_ROOT):/home/ak/Projects/dotfiles dotfiles-dev-arch bash

# AUR builds land here.
clean:
	rm -rf build
