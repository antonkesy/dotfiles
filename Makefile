.PHONY: install_base install_all build_docker clean_docker demo test

install_base:
	./link.sh
	./install_scripts/base.sh
	${MAKE} -C ./built_from_source/neovim
	${MAKE} -C ./built_from_source/alacritty

install_all: install_base
	./install_scripts/all_selective.sh

build_docker:
	docker build -t dotfiles_test .

clean_docker:
	docker image rm dotfiles_test --force

demo: build_docker
	docker run -it dotfiles_test

test: clean_docker build_docker
	docker run dotfiles_test bash -c "cd /home/root/dotfiles && make install_base"
