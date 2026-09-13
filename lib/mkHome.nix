# Standalone homeManagerConfiguration for the one configuration this flake has.
#
# pkgs already carries nixpkgs-config.nix; home-manager copies pkgs.config into
# its own nixpkgs.* options, so the modules under modules/home never set
# nixpkgs.* themselves. That keeps them importable from ../setup's NixOS flake,
# where useGlobalPkgs forbids it.
{ inputs, pkgs }:
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [ ../modules/home ];
}
