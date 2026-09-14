# flakes, however nix was installed
export NIX_CONFIG := experimental-features = nix-command flakes
# not in PATH before the first switch: run it from the flake's pinned input
HM := $(shell command -v home-manager 2>/dev/null || echo "nix run .\#home-manager --")

.PHONY: help switch update clean

help:
	@echo "homeConfigurations.ak (everything under ~):"
	@echo "  switch  - build and activate"
	@echo "  update  - update flake inputs"
	@echo "  clean   - remove ./result, user-level nix garbage"

switch:
	$(HM) switch --flake .#ak -b hm-bak

update:
	nix flake update

clean:
	rm -f result
	nix-collect-garbage -d
