# extra compiler majors, suffixed (gcc-14, javac-17); defaults stay in development.nix
{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  suffixed =
    suffix: bins: pkg:
    pkgs.runCommand "${pkg.name}-as-${suffix}" { } ''
      mkdir -p "$out/bin"
      for b in ${lib.escapeShellArgs bins}; do
        if [ -e "${pkg}/bin/$b" ]; then
          ln -s "${pkg}/bin/$b" "$out/bin/$b-${suffix}"
        fi
      done
    '';

  gcc = suffix: pkg: [
    (suffixed suffix [
      "gcc"
      "g++"
      "cpp"
    ] pkg)
    (suffixed suffix [ "gcov" ] pkg.cc) # gcov is not in the wrapper
  ];

  clangBins = [
    "clang"
    "clang++"
  ];
  jdkBins = [
    "java"
    "javac"
    "jar"
    "javap"
    "jshell"
    "jlink"
    "jpackage"
    "keytool"
  ];
  nodeBins = [
    "node"
    "npm"
    "npx"
  ];

  # pythons removed from nixpkgs, taken from old release pins (flake.nix)
  oldPkgs =
    input: insecure:
    import input {
      inherit (pkgs.stdenv.hostPlatform) system;
      config.permittedInsecurePackages = insecure;
    };
  py35 = oldPkgs inputs.nixpkgs-py35 [ ];
  py36 = oldPkgs inputs.nixpkgs-py36 [ ];
  py27-37 = oldPkgs inputs.nixpkgs-py27-37 [ "python-2.7.18.6" ];
  py38 = oldPkgs inputs.nixpkgs-py38 [ ];
  py39 = oldPkgs inputs.nixpkgs-py39 [ ];
  py310 = oldPkgs inputs.nixpkgs-py310 [ ];

  jdks = {
    "8" = pkgs.jdk8;
    "11" = pkgs.jdk11;
    "17" = pkgs.jdk17;
    "21" = pkgs.jdk21;
    "25" = pkgs.jdk25;
  };
in
{
  home.packages = [
    # --- clang ---
    (suffixed "18" clangBins pkgs.clang_18)
    (suffixed "19" clangBins pkgs.clang_19)
    (suffixed "20" clangBins pkgs.clang_20)

    # --- node ---
    (suffixed "22" nodeBins pkgs.nodejs_22)
    (suffixed "26" nodeBins pkgs.nodejs_26)

    # --- go ---
    (suffixed "1.26" [ "go" ] pkgs.go_1_26)

    # --- zig ---
    (suffixed "0.13" [ "zig" ] pkgs.zig_0_13)
    (suffixed "0.14" [ "zig" ] pkgs.zig_0_14)

    # --- python / haskell --- already versioned; prios must differ or buildEnv collides
    # (default python3 from development.nix keeps prio 5 and wins python/python3/pip)
    (lib.setPrio 20 py27-37.python27)
    (lib.setPrio 21 py35.python35)
    (lib.setPrio 22 py36.python36)
    (lib.setPrio 23 py27-37.python37)
    (lib.setPrio 24 py38.python38)
    (lib.setPrio 25 py39.python39)
    (lib.setPrio 26 py310.python310)
    (lib.setPrio 27 pkgs.python311)
    (lib.setPrio 28 pkgs.python312)
    (lib.setPrio 29 pkgs.python313)
    (lib.setPrio 30 pkgs.python314)
    (lib.setPrio 13 pkgs.haskell.compiler.ghc94)
    (lib.setPrio 14 pkgs.haskell.compiler.ghc96)
    (lib.setPrio 15 pkgs.haskell.compiler.ghc98)
  ]
  # --- gcc ---
  ++ gcc "13" pkgs.gcc13
  ++ gcc "14" pkgs.gcc14
  ++ gcc "16" pkgs.gcc16
  ++ lib.mapAttrsToList (v: suffixed v jdkBins) jdks;

  home.file = lib.mapAttrs' (
    v: p: lib.nameValuePair ".local/jdks/${v}" { source = "${p}/lib/openjdk"; }
  ) jdks;
}
