.PHONY: dependencies paru yay

dependencies:
	sudo pacman -S --noconfirm --needed base-devel git

paru: dependencies
	# git update-index --assume-unchanged ./arch/AUR_helpers/paru/
	cd paru && makepkg -si --noconfirm

yay: dependencies
	cd yay && makepkg -si --noconfirm
