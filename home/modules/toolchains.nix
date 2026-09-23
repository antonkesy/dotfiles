# extra compiler majors, suffixed (gcc-14, javac-17); defaults stay in development.nix
{ lib, pkgs, ... }:
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
    (lib.setPrio 11 pkgs.python311)
    (lib.setPrio 12 pkgs.python312)
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
