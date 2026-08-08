# Throwaway QEMU host used by `make demo` to showcase the real desktop config.
# Built with `nix build .#nixosConfigurations.demo.config.system.build.vm` — no
# nixos-rebuild required, `system.build.vm` is a plain derivation.
{ lib, ... }:
{
  imports = [
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/hardware.nix
  ];

  # Load-bearing: the runner script is named run-${config.system.name}-vm, and
  # system.name defaults to networking.hostName. Set in lib/mkHost.nix.

  # No real disk — the VM variant supplies its own root filesystem, but the
  # plain toplevel still needs a stub so `nix flake check` can evaluate.
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  boot.loader.grub.useOSProber = lib.mkForce false;
  boot.loader.grub.device = lib.mkForce "/dev/vda";
  boot.loader.grub.efiSupport = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  # Passwordless demo: log straight into the Hyprland session.
  users.users.ak.initialPassword = "demo";
  users.users.root.initialPassword = "demo";
  security.sudo.wheelNeedsPassword = false;
  # gdm is the display manager (modules/nixos/desktop.nix); autologin straight
  # into the Hyprland session set as services.displayManager.defaultSession.
  services.displayManager.autoLogin = {
    enable = true;
    user = "ak";
  };

  # No SMART-capable disks in a VM; smartd just fails the boot otherwise.
  services.smartd.enable = false;

  # Software rendering: no host GPU is passed through.
  environment.sessionVariables = {
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    AQ_NO_ATOMIC = "1";
  };

  virtualisation.vmVariant.virtualisation = {
    memorySize = 8192;
    cores = 4;
    diskSize = 32768;
    graphics = true;
    # virtio-gpu gives Hyprland a DRM node; xres/yres set the initial size.
    # `resolution` is deliberately NOT used — it only feeds grub and Xorg.
    qemu.options = [
      "-device virtio-vga-gl,xres=1920,yres=1080"
      "-display gtk,gl=on,show-cursor=on"
    ];
  };
}
