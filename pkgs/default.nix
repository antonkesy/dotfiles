# Overlay for everything that is not in nixpkgs.
#
# ponytail: dropped two candidates rather than packaging them —
#   ttf-croscore   -> liberation_ttf is metric-compatible with the same MS metrics
#   thetic/extract -> p7zip + unzip already cover it
final: _prev: {
  screenpen = final.callPackage ./screenpen.nix { };
}
