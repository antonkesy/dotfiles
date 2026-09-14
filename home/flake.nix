{
  description = "antonkesy home (Home Manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = import ./lib/nixpkgs-config.nix;
      };

      mkHome = import ./lib/mkHome.nix { inherit inputs pkgs; };
    in
    {
      homeConfigurations.ak = mkHome;

      packages.${system} = {
        inherit (home-manager.packages.${system}) home-manager;
        default = home-manager.packages.${system}.home-manager;
      };

      formatter.${system} = pkgs.nixfmt-tree;

      checks.${system}.ak = self.homeConfigurations.ak.activationPackage;
    };
}
