# Replaces tasks/hardware/nvidia.yml and tasks/ai/ollama.yml.
# The old playbook ran `nvidia-ctk runtime configure --runtime=docker` to rewrite
# /etc/docker/daemon.json and hand-wrote /etc/systemd/system/ollama.service
# without ever creating the ollama user; both are first-class options here.
{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true; # nvidia-open
    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
  };

  hardware.nvidia-container-toolkit.enable = true;

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
  };

  environment.systemPackages = with pkgs; [
    cudaPackages.cudatoolkit
    cudaPackages.cuda_nvcc
    nvtopPackages.nvidia
  ];

  # The kernel param the old grub file kept commented out for nvidia eGPUs:
  #   boot.kernelParams = [ "nvidia.NVreg_OpenRmEnableUnsupportedGpus=1" ];
  #   boot.blacklistedKernelModules = [ "nouveau" ];
}
