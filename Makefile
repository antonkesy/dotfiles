.PHONY: install_base install_all demo fresh_docker test demo

install_base:
	./install_scripts/base.sh
	./link.sh
	./built_from_source/neovim/install.sh
	./built_from_source/alacritty/install.sh

install_all: install_base
	./install_scripts/all_selective.sh

fresh_docker:
	docker image rm dotfiles_test --force
	docker build -t dotfiles_test .

demo: fresh_docker
	docker run -it dotfiles_test bash -c "cd /home/root/dotfiles && make install_base"

test: fresh_docker
	docker run dotfiles_test bash -c "cd /home/root/dotfiles && make install_base"
