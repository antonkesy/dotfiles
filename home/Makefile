export NIX_CONFIG := experimental-features = nix-command flakes
HM := $(shell command -v home-manager 2>/dev/null || echo "nix run .\#home-manager --")

.PHONY: help switch update clean

help:
	@echo "  switch - build and activate"
	@echo "  update - update flake inputs"
	@echo "  clean  - remove ./result, user-level nix garbage"

switch:
	$(HM) switch --flake .#ak -b hm-bak

update:
	nix flake update

clean:
	rm -f result
	nix-collect-garbage -d
