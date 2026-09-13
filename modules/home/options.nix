# ak.nixos is derived from `osConfig`: home-manager passes the NixOS
# configuration as that module argument when it runs as a NixOS module (the
# flake in ../setup) and null when run standalone (home-manager switch on Arch,
# Ubuntu, WSL). On NixOS the system owns the session; standalone, this module
# enables the generic-Linux shims (XDG_DATA_DIRS, session vars, nix profile in
# the session) instead.
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

    dotfilesDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/Projects/dotfiles";
      description = ''
        Live checkout of this repo. modules/home/dotfiles.nix and nvim.nix
        symlink into it out of the store, so it is load-bearing.
      '';
    };
  };

  config.targets.genericLinux = {
    enable = !config.ak.nixos;
    # No Nix-built GUI programs here (they come from the distro via ../setup),
    # so the /run/opengl-driver shim is not needed.
    gpu.enable = false;
  };
}
