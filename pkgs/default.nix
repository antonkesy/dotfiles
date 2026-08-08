# Overlay for everything that is not in nixpkgs.
#
# ponytail: dropped two candidates rather than packaging them —
#   ttf-croscore   -> liberation_ttf is metric-compatible with the same MS metrics
#   thetic/extract -> p7zip + unzip already cover it
final: prev: {
  webots = final.callPackage ./webots.nix { };
  screenpen = final.callPackage ./screenpen.nix { };
  dbc-utility = final.callPackage ./dbc-utility.nix { };

  tmuxPlugins = prev.tmuxPlugins // {
    cowboy = final.callPackage ./tmux-cowboy.nix { };
  };
}
