HOST ?= $(shell hostname 2>/dev/null || cat /etc/hostname)
FLAKE := .
# Every nix call from here (and the ones home-manager makes internally) needs
# flakes, whichever way nix was installed on the host.
export NIX_CONFIG := experimental-features = nix-command flakes
# home-manager is in PATH after the first switch (programs.home-manager.enable);
# before that, run it straight from this flake's pinned input.
HM := $(shell command -v home-manager 2>/dev/null || echo "nix run $(FLAKE)\#home-manager --")

.PHONY: help switch dry build check update fmt clean use-ssh

help:
	@echo "switch      - build and activate homeConfigurations.$(HOST) (HOST=<name> to override)"
	@echo "dry         - show what switch would do"
	@echo "build       - build without activating"
	@echo "check       - evaluate every host (nix flake check --no-build)"
	@echo "update      - update flake inputs"
	@echo "fmt         - format all nix files"
	@echo "clean       - remove build outputs and collect user-level nix garbage"
	@echo "use-ssh     - switch origin remote (and submodules) from https to ssh (github.com/antonkesy/*)"

# On NixOS home-manager is part of the system generation (../setup); a
# standalone switch would fight the NixOS module over ~/.config.
switch: guard-nixos
	$(HM) switch --flake $(FLAKE)#$(HOST) -b hm-bak

dry: guard-nixos
	$(HM) switch --flake $(FLAKE)#$(HOST) -b hm-bak -n

build:
	nix build $(FLAKE)#homeConfigurations.$(HOST).activationPackage

check:
	nix flake check --no-build

update:
	nix flake update

fmt:
	nix fmt

clean:
	rm -f result
	nix-collect-garbage -d

use-ssh:
	@$(CURDIR)/scripts/use-ssh-remote.sh
	@git submodule foreach --recursive $(CURDIR)/scripts/use-ssh-remote.sh

guard-nixos:
	@if [ -e /etc/NIXOS ]; then \
		echo "This is NixOS: home-manager is applied by 'make switch' in ~/Projects/setup." >&2; \
		exit 1; \
	fi
