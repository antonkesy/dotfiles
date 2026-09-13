# Standalone home-manager on a non-NixOS distro (Arch, Ubuntu, WSL): the
# generic-Linux shims (XDG_DATA_DIRS, session vars, nix profile in the
# session) are always on.
{ config, lib, ... }:
{
  options.ak.dotfilesDir = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/Projects/dotfiles";
    description = ''
      Live checkout of this repo. modules/home/{dotfiles,desktop,nvim}.nix
      symlink into it out of the store, so it is load-bearing.
    '';
  };

  config.targets.genericLinux = {
    enable = true;
    # No Nix-built GUI programs here (they come from the distro via ../setup),
    # so the /run/opengl-driver shim is not needed.
    gpu.enable = false;
  };
}
