# Two halves, each with its own Makefile:
#   home/            everything under ~ (Home Manager flake), the same on every distro
#   system/<Distro>  what needs root, per distro
# This one only forwards; command-line variables (IN_DOCKER=) reach the sub-make.
HOME_TARGETS := switch dry build check update
ARCH_TARGETS := arch galaxy ansible-check ansible-syntax lint test-arch dev-arch

.PHONY: help clean use-ssh wsl clean-home clean-arch $(HOME_TARGETS) $(ARCH_TARGETS)

help:
	@echo "Home (home/, homeConfigurations.ak):"
	@echo "  switch         - build and activate"
	@echo "  dry            - show what switch would do"
	@echo "  build          - build without activating"
	@echo "  check          - evaluate (nix flake check --no-build)"
	@echo "  update         - update flake inputs"
	@echo "System (system/<Distro>):"
	@echo "  arch           - ansible playbook, every role, host ak (system/Arch)"
	@echo "  ansible-check  - dry run of the playbook on this machine"
	@echo "  ansible-syntax - syntax-check the playbook"
	@echo "  lint           - ansible-lint"
	@echo "  test-arch      - ansible --check inside the Arch container (docker)"
	@echo "  dev-arch       - shell in the Arch container, repo bind-mounted"
	@echo "  wsl            - Ubuntu/WSL2 bootstrap (apt, wsl.conf, single-user nix, switch)"
	@echo "Repo:"
	@echo "  clean          - home/result, user-level nix garbage, system/Arch/build"
	@echo "  use-ssh        - switch origin remote (and submodules) from https to ssh (github.com/antonkesy/*)"

$(HOME_TARGETS):
	$(MAKE) -C home $@

$(ARCH_TARGETS):
	$(MAKE) -C system/Arch $@

clean: clean-home clean-arch

clean-home:
	$(MAKE) -C home clean

clean-arch:
	$(MAKE) -C system/Arch clean

use-ssh:
	@$(CURDIR)/scripts/use-ssh-remote.sh
	@git submodule foreach --recursive $(CURDIR)/scripts/use-ssh-remote.sh

wsl:
	bash system/Ubuntu-26.04-WSL2/bootstrap.sh
