# Every nix call from here (and the ones home-manager makes internally) needs
# flakes, whichever way nix was installed on the host.
export NIX_CONFIG := experimental-features = nix-command flakes
# home-manager is in PATH after the first switch (programs.home-manager.enable);
# before that, run it straight from this flake's pinned input.
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
