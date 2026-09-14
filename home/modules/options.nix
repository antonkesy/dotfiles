{ config, lib, ... }:
{
  options.ak.dotfilesDir = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/Projects/dotfiles";
    description = "Live checkout that the modules symlink into.";
  };

  config.targets.genericLinux = {
    enable = true;
    gpu.enable = false;
  };
}
