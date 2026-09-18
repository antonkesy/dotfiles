{ ... }:
{
  imports = [
    ./options.nix
    ./base.nix
    ./terminal.nix
    ./dotfiles.nix
    ./desktop.nix
    ./nextcloud.nix
    ./nvim.nix
    ./git.nix
    ./development.nix
    ./toolchains.nix
    ./containers.nix
  ];

  home.username = "ak";
  home.homeDirectory = "/home/ak";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
  xdg.enable = true;
}
