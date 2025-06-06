.PHONY: all dep gSnap clipboard-indicator lock-keys draw-on-screen

INSTALL_DIR=~/.local/share/gnome-shell/extensions

all: gSnap clipboard-indicator lock-keys draw-on-screen

dep:
	sudo apt-get install -y gnome-browser-connector gnome-terminal gnome-shell-extension-manager

GSNAP_NAME=gSnap@micahosborn
gSnap: dep
	# https://github.com/GnomeSnapExtensions/gSnap
	# https://github.com/GnomeSnapExtensions/gSnap/blob/releases/23/DEVELOPING.md
	cp -rf ./gSnap ${INSTALL_DIR}/${GSNAP_NAME}
	cd ${INSTALL_DIR}/${GSNAP_NAME} && \
	npm ci && \
	npm run install-extension
	gnome-extensions enable ${GSNAP_NAME}

clipboard-indicator: dep
	# https://extensions.gnome.org/extension/779/clipboard-indicator/
	cp -rf ./gnome-shell-extension-clipboard-indicator ${INSTALL_DIR}/clipboard-indicator@tudmotu.com
	gnome-extensions enable clipboard-indicator@tudmotu.com

lock-keys: dep
	# https://extensions.gnome.org/extension/36/lock-keys/
	cp -rf ./gnome-shell-extension-lockkeys/lockkeys@vaina.lt/ ${INSTALL_DIR}/lockkeys@vaina.lt
	gnome-extensions enable lockkeys@vaina.lt

draw-on-screen: dep
	# https://github.com/daveprowse/Draw-On-Gnome
	cp -rf ./Draw-On-Gnome ${INSTALL_DIR}/draw-on-gnome@daveprowse.github.io
	gnome-extensions enable draw-on-gnome@daveprowse.github.io
