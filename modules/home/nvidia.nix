# CUDA userspace. ~5 GB closure, so it is its own flag. The kernel driver,
# nvidia-container-toolkit and ollama-cuda are system-side (../setup). On Arch
# the distro `cuda`/`nvtop` from the ansible nvidia role are the lighter
# choice; this is meant for akdesk on NixOS.
{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.ak.nvidia.enable {
  home.packages = with pkgs; [
    cudaPackages.cudatoolkit
    cudaPackages.cuda_nvcc
    nvtopPackages.nvidia
  ];
}
