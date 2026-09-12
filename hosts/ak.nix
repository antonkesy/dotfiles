# Generic desktop on a non-NixOS distro (Arch). The compositor stack, drivers
# and daemons come from ../setup's ansible roles; this installs the rest.
{ ... }:
{
  ak = {
    desktop.enable = true;
    development.enable = true;
    containers.enable = true;
  };

  # With an NVIDIA card the Nix-built GL shim needs the userspace libraries of
  # the exact driver the distro kernel module runs. Pin them here (the ansible
  # nvidia role prints the version), then re-run `sudo non-nixos-gpu-setup`:
  #
  # targets.genericLinux.gpu.nvidia = {
  #   enable = true;
  #   version = "580.82.07";
  #   sha256 = "sha256-...";   # nix store prefetch-file https://download.nvidia.com/XFree86/Linux-x86_64/<v>/NVIDIA-Linux-x86_64-<v>.run
  # };
}
