.PHONY: install_base install_all_auto install_all build_docker clean_docker demo test

install_base:
	./link.sh
	${MAKE} -C ./install_scripts/base
	${MAKE} -C ./built_from_source/neovim
	${MAKE} -C ./built_from_source/alacritty

install_all_auto: install_base
	${MAKE} -C ./install_scripts/auto

install_all: install_all_auto
	${MAKE} -C ./install_scripts/manual

build_docker:
	docker build -t dotfiles_test .

clean_docker:
	docker image rm dotfiles_test --force

demo:
	docker run -it dotfiles_test

test_base: clean_docker build_docker
	docker run dotfiles_test bash -c "cd /home/root/dotfiles && make install_base"

test_all_auto: clean_docker build_docker
	docker run dotfiles_test bash -c "cd /home/root/dotfiles && make install_all_auto"
