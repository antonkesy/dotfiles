FLAKE := .
# Every nix call from here (and the ones home-manager makes internally) needs
# flakes, whichever way nix was installed on the host.
export NIX_CONFIG := experimental-features = nix-command flakes
# home-manager is in PATH after the first switch (programs.home-manager.enable);
# before that, run it straight from this flake's pinned input.
HM := $(shell command -v home-manager 2>/dev/null || echo "nix run $(FLAKE)\#home-manager --")

# System half (what needs root, per distro) lives in system/<Distro>. The Arch
# targets forward to system/Arch/Makefile; command-line variables (HOST=,
# IN_DOCKER=) reach the sub-make.
ARCH_TARGETS := arch galaxy ansible-check ansible-syntax lint test-arch dev-arch

.PHONY: help switch dry build check update clean use-ssh wsl clean-arch $(ARCH_TARGETS)

help:
	@echo "Home (this flake, homeConfigurations.ak):"
	@echo "  switch         - build and activate"
	@echo "  dry            - show what switch would do"
	@echo "  build          - build without activating"
	@echo "  check          - evaluate (nix flake check --no-build)"
	@echo "  update         - update flake inputs"
	@echo "  clean          - remove build outputs, user-level nix garbage, system/Arch/build"
	@echo "  use-ssh        - switch origin remote (and submodules) from https to ssh (github.com/antonkesy/*)"
	@echo "System (system/<Distro>):"
	@echo "  arch           - ansible playbook for profile HOST=<hostname> (system/Arch)"
	@echo "  ansible-check  - dry run of the playbook on this machine"
	@echo "  ansible-syntax - syntax-check the playbook"
	@echo "  lint           - ansible-lint"
	@echo "  test-arch      - ansible --check inside the Arch container (docker)"
	@echo "  dev-arch       - shell in the Arch container, repo bind-mounted"
	@echo "  wsl            - Ubuntu/WSL2 bootstrap (apt, wsl.conf, single-user nix, switch)"

switch:
	$(HM) switch --flake $(FLAKE)#ak -b hm-bak

dry:
	$(HM) switch --flake $(FLAKE)#ak -b hm-bak -n

build:
	nix build $(FLAKE)#homeConfigurations.ak.activationPackage

check:
	nix flake check --no-build

update:
	nix flake update

clean: clean-arch
	rm -f result
	nix-collect-garbage -d

use-ssh:
	@$(CURDIR)/scripts/use-ssh-remote.sh
	@git submodule foreach --recursive $(CURDIR)/scripts/use-ssh-remote.sh

$(ARCH_TARGETS):
	$(MAKE) -C system/Arch $@

clean-arch:
	$(MAKE) -C system/Arch clean

wsl:
	bash system/Ubuntu-26.04-WSL2/bootstrap.sh
