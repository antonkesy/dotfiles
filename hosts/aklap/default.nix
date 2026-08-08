# Dell laptop: fingerprint reader, no NVIDIA, no VirtualBox.
{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/apps.nix
    ../../modules/nixos/development.nix
    ../../modules/nixos/containers.nix
    ../../modules/nixos/hardware.nix
    ../../modules/nixos/laptop.nix
  ];
}
