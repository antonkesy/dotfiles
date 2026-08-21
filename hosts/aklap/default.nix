# Dell laptop: same module set as akdesk plus laptop.nix (fingerprint, power
# management), minus VirtualBox and nvidia.nix (no NVIDIA GPU on this machine).
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
