# Overlay for everything that is not in nixpkgs.
#
final: _prev: {
  screenpen = final.callPackage ./screenpen.nix { };
}
