HOST ?= $(shell hostname 2>/dev/null || cat /etc/hostname)
FLAKE := .

.PHONY: help switch boot build test check update fmt demo demo-clean clean

help:
	@echo "switch      - build and activate the config for HOST=$(HOST)"
	@echo "boot        - build and activate on next boot"
	@echo "build       - build without activating"
	@echo "check       - evaluate and build every host (nix flake check)"
	@echo "update      - update flake inputs"
	@echo "fmt         - format all nix files"
	@echo "demo        - boot the desktop config in a QEMU VM"
	@echo "demo-clean  - throw away the demo VM disk"

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
