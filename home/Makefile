export NIX_CONFIG := experimental-features = nix-command flakes
HM := $(shell command -v home-manager 2>/dev/null || echo "nix run .\#home-manager --")

.PHONY: help switch update clean import-keys

help:
	@echo "  switch      - build and activate"
	@echo "  update      - update flake inputs"
	@echo "  import-keys - ssh/gpg keys from the NAS staging copy into ~"
	@echo "  clean       - remove ./result, user-level nix garbage"

switch:
	$(HM) switch --flake .#ak -b hm-bak

# Keys are the one thing home-manager must not hold: they never go in the repo.
import-keys:
	bash import-keys.sh

update:
	nix flake update

clean:
	rm -f result
	nix-collect-garbage -d
