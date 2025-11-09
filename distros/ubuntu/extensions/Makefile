.PHONY: all dep gSnap clipboard-indicator lock-keys draw-on-screen

INSTALL_DIR=~/.local/share/gnome-shell/extensions

all: gSnap clipboard-indicator lock-keys draw-on-screen vitals

dep:
	sudo apt-get install -y gnome-browser-connector gnome-terminal gnome-shell-extension-manager
	mkdir -p ${INSTALL_DIR}

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
	rm ${INSTALL_DIR}/clipboard-indicator@tudmotu.com -rf || true
	cp -rf ./gnome-shell-extension-clipboard-indicator ${INSTALL_DIR}/clipboard-indicator@tudmotu.com
	gnome-extensions enable clipboard-indicator@tudmotu.com

lock-keys: dep
	# https://extensions.gnome.org/extension/36/lock-keys/
	rm ${INSTALL_DIR}/lockkeys@vaina.lt -rf || true
	cp -rf ./gnome-shell-extension-lockkeys/lockkeys@vaina.lt ${INSTALL_DIR}/lockkeys@vaina.lt
	gnome-extensions enable lockkeys@vaina.lt

draw-on-screen: dep
	# https://github.com/daveprowse/Draw-On-Gnome
	rm ${INSTALL_DIR}/draw-on-gnome@daveprowse.github.io -rf || true
	cp -rf ./Draw-On-Gnome ${INSTALL_DIR}/draw-on-gnome@daveprowse.github.io
	gnome-extensions enable draw-on-gnome@daveprowse.github.io

display-config-switch: dep
	# https://gitlab.com/knokelmaat/display-configuration-switcher-gnome-extension
	rm ${INSTALL_DIR}/display-configuration-switcher@knokelmaat.gitlab.com -rf || true
	cp -rf ./display-configuration-switcher-gnome-extension ${INSTALL_DIR}/display-configuration-switcher@knokelmaat.gitlab.com
	gnome-extensions enable display-configuration-switcher@knokelmaat.gitlab.com

activate-gnome: dep
	# https://github.com/isjerryxiao/gnome-shell-extension-activate-gnome
	rm ${INSTALL_DIR}/activate_gnome@isjerryxiao -rf || true
	cp -rf ./gnome-shell-extension-activate-gnome ${INSTALL_DIR}/activate_gnome@isjerryxiao
	gnome-extensions enable activate_gnome@isjerryxiao

vitals: dep
	# https://github.com/corecoding/Vitals#
	sudo apt install -y gir1.2-gtop-2.0 lm-sensors
	rm ${INSTALL_DIR}/Vitals@CoreCoding.com -rf || true
	cp -rf ./Vitals ${INSTALL_DIR}/Vitals@CoreCoding.com
	gnome-extensions enable Vitals@CoreCoding.com
