# Throwaway QEMU host used by `make demo` to showcase the real desktop config.
# Built with `nix build .#nixosConfigurations.demo.config.system.build.vm` — no
# nixos-rebuild required, `system.build.vm` is a plain derivation.
{ lib, ... }:
{
  # Same module set as akdesk, minus the two things a VM has no hardware for:
  # nvidia.nix (no GPU passthrough) and virtualbox (nested virt).
  imports = [
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/apps.nix
    ../../modules/nixos/development.nix
    ../../modules/nixos/containers.nix
    ../../modules/nixos/hardware.nix
  ];

  # waydroid needs binder kernel modules that are not wired up in the VM; it
  # would only ever show up as a failed unit here.
  virtualisation.waydroid.enable = lib.mkForce false;

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

  # Software rendering: no host GPU is passed through, so mesa falls back to
  # llvmpipe on the virtio-gpu DRM node.
  environment.sessionVariables = {
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    AQ_NO_ATOMIC = "1";
    LIBGL_ALWAYS_SOFTWARE = "1";
  };

  virtualisation.vmVariant.virtualisation = {
    memorySize = 8192;
    cores = 4;
    diskSize = 32768;
    graphics = true;
    # virtio-vga gives Hyprland a DRM node; xres/yres set the initial size.
    # `resolution` is deliberately NOT used — it only feeds grub and Xorg.
    #
    # No `gl=on`/virtio-vga-gl: virgl needs qemu's GTK to obtain a host GL
    # context, which fails on plenty of hosts with
    #   "GtkGLArea console lacks DMABUF support"
    #   epoxy_get_proc_address: Assertion `0 && "Couldn't find current GLX or EGL context"`
    # llvmpipe is slower but starts everywhere. To opt back in on a host where
    # virgl does work:
    #   QEMU_OPTS="-display gtk,gl=on" make demo
    qemu.options = [
      "-device virtio-vga,xres=1920,yres=1080"
      "-display gtk,show-cursor=on"
    ];
  };
}
