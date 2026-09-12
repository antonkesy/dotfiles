{ ... }:
{
  imports = [
    ./options.nix
    ./base.nix
    ./terminal.nix
    ./dotfiles.nix
    ./nvim.nix
    ./git.nix
    ./seed.nix
    ./desktop.nix
    ./fonts.nix
    ./apps.nix
    ./development.nix
    ./containers.nix
    ./nvidia.nix
  ];

  home.username = "ak";
  home.homeDirectory = "/home/ak";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
  xdg.enable = true;
}
