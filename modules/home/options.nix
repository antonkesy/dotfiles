# Feature flags. Every host module under hosts/ is just a set of these.
#
# ak.nixos is derived from `osConfig`: home-manager passes the NixOS
# configuration as that module argument when it runs as a NixOS module (the
# flake in ../setup) and null when run standalone (home-manager switch on Arch,
# Ubuntu, WSL). On NixOS the system owns agents, keyring, GL drivers and the
# session; standalone, this module enables the generic-Linux shims instead.
{
  config,
  lib,
  osConfig ? null,
  ...
}:
{
  options.ak = {
    nixos = lib.mkOption {
      type = lib.types.bool;
      default = osConfig != null;
      defaultText = "true when evaluated as a NixOS Home Manager module";
      description = "Whether the system is NixOS (managed by ../setup).";
    };

    wsl = lib.mkEnableOption "WSL tweaks (no desktop, no GPU setup)";

    desktop.enable = lib.mkEnableOption "GUI apps, wayland helper tools and fonts";
    development.enable = lib.mkEnableOption "language toolchains and build tools";
    containers.enable = lib.mkEnableOption "docker CLI plugins (the daemon comes from the system)";
    nvidia.enable = lib.mkEnableOption "CUDA userspace and nvtop (multi-GB closure)";

    dotfilesDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/Projects/dotfiles";
      description = ''
        Live checkout of this repo. modules/home/dotfiles.nix and nvim.nix
        symlink into it out of the store, so it is load-bearing.
      '';
    };
  };

  config = {
    assertions = [
      {
        assertion = !(config.ak.wsl && config.ak.desktop.enable);
        message = "ak.wsl and ak.desktop.enable are mutually exclusive";
      }
    ];

    # Non-NixOS: XDG_DATA_DIRS for desktop entries, session vars, nix-daemon
    # profile, and the /run/opengl-driver shim (targets.genericLinux.gpu) that
    # gives Nix-built GUI apps working OpenGL. The gpu module installs
    # `non-nixos-gpu-setup`; run it once with sudo after the first switch.
    targets.genericLinux.enable = !config.ak.nixos;
    targets.genericLinux.gpu.enable = lib.mkDefault (
      !config.ak.nixos && config.ak.desktop.enable && !config.ak.wsl
    );
  };
}
