# Dell laptop. NixOS, system config in ../setup.
{ ... }:
{
  ak = {
    desktop.enable = true;
    development.enable = true;
    containers.enable = true;
  };
}
