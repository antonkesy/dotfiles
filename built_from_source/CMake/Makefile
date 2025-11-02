all: build alternative

.PHONY: dependencies build clean alternative

dependencies:
	sudo apt install build-essential checkinstall zlib1g-dev libssl-dev -y

build: dependencies
	cd CMake && \
  ./bootstrap -- -DCMAKE_BUILD_TYPE=Release && \
  make && \
	sudo make install

alternative:
	sudo update-alternatives --install /usr/bin/cmake cmake /usr/local/bin/cmake 100
	sudo update-alternatives --install /usr/bin/ctest ctest /usr/local/bin/ctest 100
	sudo update-alternatives --install /usr/bin/cpack cpack /usr/local/bin/cpack 100

clean:
	cd CMake && make clean && git clean -fdx
