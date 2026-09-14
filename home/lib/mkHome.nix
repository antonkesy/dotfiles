{ inputs, pkgs }:
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [ ../modules ];
}
