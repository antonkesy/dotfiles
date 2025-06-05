#!/bin/bash

if [ -f /.dockerenv ] || [ "$IS_DOCKER_BUILD" = "true" ]; then
	echo "Skipping flutter installation in Docker container."
else
	sudo snap install flutter --classic
	flutter doctor

	# TODO: add dart install
	dart pub global activate melos
fi
