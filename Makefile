.PHONY: install_base install_all demo

install_base:
	./install_scripts/base.sh
	./link.sh
	./built_from_source/neovim/install.sh
	./built_from_source/alacritty/install.sh

install_all: install_base
	./install_scripts/all_selective.sh

demo:
	docker image rm dotfiles_test --force
	docker build -t dotfiles_test .
	docker run -it dotfiles_test bash -c "cd /home/root/dotfiles && make install_base"
