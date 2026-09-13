FLAKE := .
# Every nix call from here (and the ones home-manager makes internally) needs
# flakes, whichever way nix was installed on the host.
export NIX_CONFIG := experimental-features = nix-command flakes
# home-manager is in PATH after the first switch (programs.home-manager.enable);
# before that, run it straight from this flake's pinned input.
HM := $(shell command -v home-manager 2>/dev/null || echo "nix run $(FLAKE)\#home-manager --")

.PHONY: help switch dry build check update clean

help:
	@echo "Home Manager flake, homeConfigurations.ak (everything under ~, every distro):"
	@echo "  switch  - build and activate"
	@echo "  dry     - show what switch would do"
	@echo "  build   - build without activating"
	@echo "  check   - evaluate (nix flake check --no-build)"
	@echo "  update  - update flake inputs"
	@echo "  clean   - remove build outputs, user-level nix garbage"

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

clean:
	rm -f result
	nix-collect-garbage -d
