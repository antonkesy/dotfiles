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
        libtmux # tmux-window-name
        tox
      ]
    ))
    swig
    uv
    ruff

    # --- node ---
    nodejs

    # --- go ---
    go
    gopls
    (lib.lowPrio gotools) # bin/bundle collides with ruby

    # --- rust ---
    rustup
    cargo-update
    libgit2
    libssh2
    openssl
    pkg-config

    # --- java ---
    jdk21
    (lib.lowPrio jdk8) # for IDEs
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

    # --- dart / flutter ---
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

    # --- c / c++ ---
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
    gtest
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
    hdf5
    vtk

    # --- latex / docs ---
    texliveFull
    plantuml
    pandoc

    # --- android ---
    android-tools
  ];

  home.extraOutputsToInstall = [
    "devman"
    "devdoc"
  ];

  home.sessionVariables.ANDROID_HOME = "$HOME/Android/Sdk";

  home.activation.rustupDefaultStable = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! ${pkgs.rustup}/bin/rustup show active-toolchain >/dev/null 2>&1; then
      run ${pkgs.rustup}/bin/rustup default stable
    fi
  '';
}
