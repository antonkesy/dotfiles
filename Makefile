# Entry points only. home/ (everything under ~, every distro) and
# system/<Distro> (what needs root) have their own Makefiles for the rest.
.PHONY: help switch dry update check arch wsl clean use-ssh

help:
	@echo "  switch   - build and activate home (home/)"
	@echo "  dry      - show what switch would do"
	@echo "  update   - update flake inputs"
	@echo "  check    - evaluate the flake, lint the ansible playbook"
	@echo "  arch     - system half of an Arch machine (system/Arch)"
	@echo "  wsl      - system half of Ubuntu on WSL2, then switch (system/Ubuntu-26.04-WSL2)"
	@echo "  clean    - build outputs, nix garbage, AUR builds"
	@echo "  use-ssh  - origin remote (and submodules) from https to ssh (github.com/antonkesy/*)"
	@echo "More: make -C home help, make -C system/Arch help"

switch dry update:
	$(MAKE) -C home $@

check:
	$(MAKE) -C home check
	$(MAKE) -C system/Arch lint

arch:
	$(MAKE) -C system/Arch arch

wsl:
	bash system/Ubuntu-26.04-WSL2/bootstrap.sh

clean:
	$(MAKE) -C home clean
	$(MAKE) -C system/Arch clean

use-ssh:
	@scripts/use-ssh-remote.sh
	@git submodule foreach --recursive $(CURDIR)/scripts/use-ssh-remote.sh
