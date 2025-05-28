all: grub gdm3

grub:
	sudo ln --symbolic --force "./default/grub" "/etc/default/grub"
	sudo update-grub

gdm3:
	sudo ln --symbolic --force "./gdm3/custom.conf" "/etc/gdm3/custom.conf"
