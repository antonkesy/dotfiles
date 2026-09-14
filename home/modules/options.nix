# Standalone home-manager on Arch and Ubuntu/WSL.
{ config, lib, ... }:
{
  options.ak.dotfilesDir = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/Projects/dotfiles";
    description = "Live checkout; {dotfiles,desktop,nvim}.nix symlink into it.";
  };

  config.targets.genericLinux = {
    enable = true;
    gpu.enable = false; # no Nix-built GUI programs
  };
}
