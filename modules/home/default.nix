# Everything under ~ on Arch and WSL: the terminal environment (packages and
# dotfiles) plus the Hyprland/DMS config. Packages that need root, a daemon or
# the GPU (drivers, the compositor stack, GUI apps) come from ../setup's
# ansible.
{ ... }:
{
  imports = [
    ./options.nix
    ./base.nix
    ./terminal.nix
    ./dotfiles.nix
    ./desktop.nix
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
