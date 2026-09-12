# Desktop workstation: NVIDIA RTX 4070. NixOS, system config in ../setup.
{ ... }:
{
  ak = {
    desktop.enable = true;
    development.enable = true;
    containers.enable = true;
    nvidia.enable = true;
  };
}
