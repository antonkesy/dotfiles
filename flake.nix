{
  description = "antonkesy NixOS system + Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # DankMaterialShell: the packages are in nixpkgs, but the NixOS/HM modules
    # only exist upstream.
    dank-material-shell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Same repo as the home/.config/nvim submodule. Needed as an input because a
    # gitlink's contents never make it into the flake's store copy, so hosts that
    # do not have this repo checked out (the demo VM) would get a dangling
    # ~/.config/nvim symlink. See modules/home/nvim.nix.
    nvim-config = {
      url = "github:antonkesy/nvim-config";
      flake = false;
    };
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      mkHost = import ./lib/mkHost.nix inputs;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ (import ./pkgs) ];
      };
    in
    {
      nixosConfigurations = {
        akdesk = mkHost "akdesk" [ ./hosts/akdesk ];
        aklap = mkHost "aklap" [ ./hosts/aklap ];
        demo = mkHost "demo" [ ./hosts/demo ];
      };

      overlays.default = import ./pkgs;

      packages.${system}.demo-vm = self.nixosConfigurations.demo.config.system.build.vm;

      formatter.${system} = pkgs.nixfmt-tree;

      # `nix flake check` builds every host end to end.
      checks.${system} = builtins.mapAttrs (
        _: cfg: cfg.config.system.build.toplevel
      ) self.nixosConfigurations;
    };
}
