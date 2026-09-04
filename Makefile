HOST ?= $(shell hostname 2>/dev/null || cat /etc/hostname)
FLAKE := .

HW := hosts/$(HOST)/hardware-configuration.nix

.PHONY: help switch boot build test check update fmt desktop demo demo-clean clean use-ssh

help:
	@echo "switch      - build and activate the config for HOST=$(HOST)"
	@echo "boot        - build and activate on next boot"
	@echo "build       - build without activating"
	@echo "check       - evaluate and build every host (nix flake check)"
	@echo "update      - update flake inputs"
	@echo "fmt         - format all nix files"
	@echo "desktop     - regenerate $(HW) (kept local), then switch"
	@echo "demo        - boot the desktop config in a QEMU VM"
	@echo "demo-clean  - throw away the demo VM disk"
	@echo "use-ssh     - switch origin remote from https to ssh (github.com/antonkesy/*)"

switch:
	sudo nixos-rebuild switch --flake $(FLAKE)#$(HOST)

boot:
	sudo nixos-rebuild boot --flake $(FLAKE)#$(HOST)

build:
	nixos-rebuild build --flake $(FLAKE)#$(HOST)

check:
	nix flake check

update:
	nix flake update

fmt:
	nix fmt

# The real hardware config belongs to this machine only, but the file is tracked
# (the stub) so the flake evaluates anywhere. skip-worktree keeps the machine's
# version out of `git status`/`git commit -a` while nix still reads it from the
# worktree. Undo with: git update-index --no-skip-worktree $(HW)
desktop:
	git update-index --no-skip-worktree $(HW)
	sudo nixos-generate-config --show-hardware-config > $(HW)
	git update-index --skip-worktree $(HW)
	$(MAKE) switch

# Showcase the finished install without touching the host: builds the `demo`
# nixosConfiguration into a runnable QEMU image. Needs only nix + kvm, not
# nixos-rebuild, because system.build.vm is a plain derivation.
demo:
	nix build $(FLAKE)#nixosConfigurations.demo.config.system.build.vm -o result-demo
	@mkdir -p .demo
	@echo "Login: ak / demo   (autologin into Hyprland; Ctrl-Alt-G releases the mouse)"
	NIX_DISK_IMAGE=$(CURDIR)/.demo/demo.qcow2 ./result-demo/bin/run-demo-vm

demo-clean:
	rm -rf .demo result-demo

clean: demo-clean
	rm -f result

use-ssh:
	@url=$$(git remote get-url origin); \
	case "$$url" in \
		https://github.com/antonkesy/*) \
			repo=$$(echo "$$url" | sed -E 's#https://github.com/antonkesy/##; s#\.git$$##'); \
			new="git@github.com:antonkesy/$$repo.git"; \
			git remote set-url origin "$$new"; \
			echo "origin -> $$new" ;; \
		git@github.com:antonkesy/*) \
			echo "origin already uses SSH: $$url" ;; \
		*) \
			echo "origin is not an antonkesy/* GitHub URL: $$url"; exit 1 ;; \
	esac
