# mkHome "hostName" -> standalone homeManagerConfiguration.
#
# pkgs already carries nixpkgs-config.nix and the pkgs/ overlay; home-manager
# copies pkgs.config/pkgs.overlays into its own nixpkgs.* options, so the
# modules under modules/home never set nixpkgs.* themselves. That keeps them
# importable from ../setup's NixOS flake, where useGlobalPkgs forbids it.
{ inputs, pkgs }:
hostName:
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = { inherit hostName; };
  modules = [
    ../modules/home
    (../hosts + "/${hostName}.nix")
  ];
}
