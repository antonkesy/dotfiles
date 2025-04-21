.PHONY: all

all:
	# Accept the EULA for Microsoft fonts
	echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | sudo debconf-set-selections
	./repositories.sh
	./python.sh
	./misc.sh
	./java.sh
	./clang.sh
	./c++.sh
	./dotnet.sh
	./flatpack.sh
	./go.sh
	./homebrew.sh
	./rust.sh
	./bazel.sh
	./haskell.sh
