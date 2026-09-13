# Language toolchains and build tools. Deliberately gone since the ansible
# days: ghcup, opam init, SDKMAN, rustup's mutable toolchain dir, pipx,
# `luarocks install` as root, `go install ...@latest` -- nixpkgs pins instead.
# `perf` is kernel-coupled and stays on the system side.
{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    # --- python ---
    (python3.withPackages (
      ps: with ps; [
        pip
        virtualenv
        opencv4
        numpy
        jupyterlab
        notebook
        libtmux # tmux-window-name (tpm plugin in home/.tmux.conf) imports it
      ]
    ))
    swig
    uv

    # --- node --- (nodejs ships npm)
    nodejs

    # --- go ---
    go
    gopls
    (lib.lowPrio gotools) # its bin/bundle loses to ruby's bundler

    # --- rust ---
    # rustup rather than a pinned rustc: `cargo-update` and the old
    # ~/.cargo/bin workflow both expect a toolchain manager.
    rustup
    cargo-update
    libgit2
    libssh2
    openssl
    pkg-config

    # --- java ---
    jdk21
    # buildEnv refuses colliding files (man pages, jstatd...) unless one side
    # has lower priority; jdk21 wins in PATH, jdk8 is still there for IDEs.
    (lib.lowPrio jdk8)
    maven
    gradle

    # --- haskell ---
    ghc
    cabal-install
    stack
    haskell-language-server

    # --- ocaml ---
    ocaml
    opam
    dune_3

    # --- lua ---
    lua5_4
    luarocks
    lua54Packages.luacheck
    stylua

    # --- dart / flutter --- (flutter ships its own dart)
    flutter

    # --- racket ---
    racket
    graphviz

    # --- dotnet ---
    (dotnetCorePackages.combinePackages [
      dotnetCorePackages.sdk_6_0
      dotnetCorePackages.sdk_7_0
      dotnetCorePackages.sdk_8_0
      dotnetCorePackages.sdk_9_0
    ])

    # --- c / c++ --- (gcc is `cc`; clang's ar/ld/c++ wrappers yield to it.
    # nixpkgs' gcc wrapper already sits at priority 10, so plain lowPrio ties.)
    gcc
    (lib.setPrio 20 clang)
    clang-tools
    llvm
    lldb
    gdb
    gnumake
    cmake
    ninja
    meson
    bear
    cppcheck
    valgrind
    gtest # provides gmock too
    boost
    (lib.setPrio 20 pkgsCross.mingwW64.buildPackages.gcc)

    # --- ruby / php / r ---
    ruby
    php
    php.packages.composer
    R

    # --- scientific / build deps ---
    ffmpeg
    qt6.qtbase
    bazel
    arduino-cli
    bison
    flex
    eigen
    spglib
    jkqtplotter
    openbabel
    libarchive
    msgpack-cxx
    glew
    mmtf-cpp
    libmsym
    # opencv itself comes with python's opencv4 above
    hdf5
    vtk

    # --- latex / docs ---
    texliveFull # includes biber
    plantuml
    pandoc

    # --- android --- (android-studio itself is GUI: ../setup)
    android-tools
  ];

  # What NixOS' documentation.dev.enable used to add system-wide: man 3 pages
  # and developer docs for the libraries above.
  home.extraOutputsToInstall = [
    "devman"
    "devdoc"
  ];

  # Android Studio's bundled SDK downloads need a writable dir.
  # (CHROME_EXECUTABLE for flutter web is set in desktop.nix.)
  home.sessionVariables.ANDROID_HOME = "$HOME/Android/Sdk";
}
