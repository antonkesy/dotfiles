# pkgs carries nixpkgs-config.nix, so modules/ never set nixpkgs.* themselves.
{ inputs, pkgs }:
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [ ../modules ];
}
