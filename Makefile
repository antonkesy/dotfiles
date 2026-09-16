.PHONY: help home arch wsl clean use-ssh

help:
	@echo "  home    - build and activate home (home/)"
	@echo "  arch    - system half of an Arch machine (system/Arch)"
	@echo "  wsl     - system half of Ubuntu on WSL2, then switch (system/Ubuntu-26.04-WSL2)"
	@echo "  clean   - build outputs, nix garbage, AUR builds"
	@echo "  use-ssh - origin remote (and submodules) from https to ssh (github.com/antonkesy/*)"
	@echo "More: make -C home help, make -C system/Arch help"

home:
	$(MAKE) -C home switch

arch:
	$(MAKE) -C system/Arch arch

wsl:
	bash system/Ubuntu-26.04-WSL2/bootstrap.sh

clean:
	$(MAKE) -C home clean
	$(MAKE) -C system/Arch clean

# https -> ssh for github.com/antonkesy/*, here and in every submodule.
define use_ssh
url=$$(git remote get-url origin 2>/dev/null) || exit 0; \
case "$$url" in \
https://github.com/antonkesy/*) \
	repo=$${url#https://github.com/}; repo=$${repo%.git}; new=git@github.com:$$repo.git; \
	git remote set-url origin "$$new"; echo "$$PWD: origin -> $$new" ;; \
git@github.com:antonkesy/*) echo "$$PWD: origin already uses SSH" ;; \
*) echo "$$PWD: origin is not an antonkesy/* GitHub URL: $$url" ;; \
esac
endef

use-ssh:
	@$(use_ssh)
	@git submodule foreach --recursive --quiet '$(use_ssh)'
