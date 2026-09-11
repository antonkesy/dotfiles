# Desktop workstation: NVIDIA RTX 4070, dual-boot with Windows.
{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/apps.nix
    ../../modules/nixos/development.nix
    ../../modules/nixos/containers.nix
    ../../modules/nixos/hardware.nix
    ../../modules/nixos/nvidia.nix
  ];

  virtualisation.virtualbox.host.enable = true;
  boot.loader.grub.useOSProber = true;
}
