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

  # tasks/containers/virtualbox.yml was skipped inside docker; on NixOS it is
  # simply not enabled on the laptop.
  virtualisation.virtualbox.host.enable = true;

  # Dual-boot: the old grub file set GRUB_DISABLE_OS_PROBER=false.
  boot.loader.grub.useOSProber = true;
}
