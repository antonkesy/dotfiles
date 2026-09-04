# Replaces every tasks/development/*.yml plus tasks/editors/latex.yml.
#
# Toolchains stay global system packages, matching the old ansible behaviour.
# What is deliberately gone: ghcup, opam init, SDKMAN, rustup's mutable
# toolchain dir, pipx, `luarocks install` as root and `go install ...@latest` —
# every one of those managed a mutable toolchain tree that nixpkgs pins instead.
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # --- python ---
    (python3.withPackages (
      ps: with ps; [
        pip
        virtualenv
        opencv4
        numpy
        jupyterlab
        notebook
      ]
    ))
    swig
    uv

    # --- node --- (nodejs ships npm)
    nodejs

    # --- go ---
    go
    gopls
    gotools

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
    jdk8
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
    dart
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
    clang
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
    perf
    gtest # provides gmock too
    boost
    pkgsCross.mingwW64.buildPackages.gcc

    # --- ruby / php / r ---
    ruby
    php
    php.packages.composer
    R

    # --- scientific / build deps from tasks/development/dev-tools.yml ---
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
    opencv
    hdf5
    vtk

    # --- latex / docs ---
    texliveFull
    plantuml
    pandoc
    biber

    # --- android ---
    android-studio
    android-tools
  ];

  # Android Studio's bundled SDK downloads need a writable dir and dynamic
  # linking against a normal FHS-ish set of libs. adb needs no module any more —
  # systemd 258 handles the uaccess rules, android-tools is above.
  programs.nix-ld.enable = true;

  environment.sessionVariables = {
    ANDROID_HOME = "$HOME/Android/Sdk";
    CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/google-chrome-stable";
  };
}
