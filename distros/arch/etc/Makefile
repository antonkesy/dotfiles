.PHONY: all grub gdm3

all: grub gdm3

grub:
	sudo unlink "/etc/default/grub" || echo "Skip if not exists"
	sudo ln --symbolic --force ${PWD}/default/grub "/etc/default/grub"
	sudo grub-mkconfig -o /boot/grub/grub.cfg
	sudo update-grub
