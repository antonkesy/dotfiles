# Declarative disk layout for the physical hosts, applied by `disko-install`
# (see README "Fresh install"). This replaces the manual parted/mkfs/mount
# dance *and* the fileSystems/swapDevices that nixos-generate-config used to
# write into hardware-configuration.nix — disko generates those from here.
#
# `--disk main /dev/sdX` at install time overrides the device below, so the
# value here is only the default for a single-NVMe machine.
{ inputs, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices.disk.main = {
    device = "/dev/nvme0n1";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [
              "fmask=0077"
              "dmask=0077"
            ];
          };
        };
        swap = {
          size = "16G";
          content.type = "swap";
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
