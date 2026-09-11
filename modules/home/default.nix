{ ... }:
{
  imports = [
    ./terminal.nix
    ./dotfiles.nix
    ./nvim.nix
    ./git.nix
    ./seed.nix
  ];

  home.username = "ak";
  home.homeDirectory = "/home/ak";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
  xdg.enable = true;
}
