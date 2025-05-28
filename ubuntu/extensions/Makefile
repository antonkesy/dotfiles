INSTALL_DIR=~/.local/share/gnome-shell/extensions

all: gSnap clipboard-indicator lock-keys

dep:
	sudo apt-get install -y gnome-browser-connector gnome-terminal gnome-shell-extension-manager

gSnap: dep
	# https://github.com/GnomeSnapExtensions/gSnap
	GSNAP=gSnap@micahosborn
	cp -rf ./gSnap ${INSTALL_DIR}/${GSNAP}
	cd ${INSTALL_DIR}/${GSNAP}
	# https://github.com/GnomeSnapExtensions/gSnap/blob/releases/23/DEVELOPING.md
	npm ci
	npm run install-extension
	gnome-extensions enable ${GSNAP}

clipboard-indicator: dep
	# https://extensions.gnome.org/extension/779/clipboard-indicator/
	cp -rf ./gnome-shell-extension-clipboard-indicator ${INSTALL_DIR}/clipboard-indicator@tudmotu.com
	gnome-extensions enable clipboard-indicator@tudmotu.com

lock-keys: dep
	# https://extensions.gnome.org/extension/36/lock-keys/
	cp -rf ./gnome-shell-extension-lockkeys/lockkeys@vaina.lt/ ${INSTALL_DIR}/lockkeys@vaina.lt
	gnome-extensions enable lockkeys@vaina.lt

# TODO: https://extensions.gnome.org/extension/4937/draw-on-you-screen-2
