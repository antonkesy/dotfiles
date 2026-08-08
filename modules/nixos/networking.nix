# Replaces tasks/desktop/core.yml (NetworkManager) and tasks/misc/vpn.yml.
{ pkgs, ... }:
{
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [ networkmanager-openconnect ];
  };

  networking.firewall.enable = true;

  environment.systemPackages = with pkgs; [
    openconnect
    nftables
  ];
}
