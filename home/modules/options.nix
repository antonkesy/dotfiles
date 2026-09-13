# Standalone home-manager on Arch and Ubuntu/WSL: the
# generic-Linux shims (XDG_DATA_DIRS, session vars, nix profile in the
# session) are always on.
{ config, lib, ... }:
{
  options.ak.dotfilesDir = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/Projects/dotfiles";
    description = ''
      Live checkout of this repo. home/modules/{dotfiles,desktop,nvim}.nix
      symlink into it out of the store, so it is load-bearing.
    '';
  };

  config.targets.genericLinux = {
    enable = true;
    # No Nix-built GUI programs here (they come from the distro via system/Arch),
    # so the /run/opengl-driver shim is not needed.
    gpu.enable = false;
  };
}
