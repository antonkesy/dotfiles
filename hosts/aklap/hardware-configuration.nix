# Kernel modules and CPU only — `hosts/disk.nix` owns fileSystems/swapDevices.
# Replace with `nixos-generate-config --no-filesystems --show-hardware-config`
# during the install; the values below are a plausible stub so the flake still
# evaluates.
{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "thunderbolt"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.kernelModules = [ "kvm-intel" ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
