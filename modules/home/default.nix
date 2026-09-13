# The terminal environment, identical on NixOS, Arch and WSL. Everything that
# depends on the distro (GUI apps, fonts, Hyprland/DMS config, drivers, CUDA)
# lives in ../setup.
{ ... }:
{
  imports = [
    ./options.nix
    ./base.nix
    ./terminal.nix
    ./dotfiles.nix
    ./nvim.nix
    ./git.nix
    ./development.nix
    ./containers.nix
  ];

  home.username = "ak";
  home.homeDirectory = "/home/ak";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
  xdg.enable = true;
}
