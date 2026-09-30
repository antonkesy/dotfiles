{
  description = "antonkesy home (Home Manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # old releases for pythons nixpkgs dropped (toolchains.nix); newest patch still in cache.nixos.org
    nixpkgs-py35 = {
      url = "github:NixOS/nixpkgs/nixos-20.03";
      flake = false;
    };
    nixpkgs-py36 = {
      url = "github:NixOS/nixpkgs/nixos-20.09";
      flake = false;
    };
    nixpkgs-py27-37 = {
      url = "github:NixOS/nixpkgs/nixos-22.11";
      flake = false;
    };
    nixpkgs-py38 = {
      url = "github:NixOS/nixpkgs/nixos-23.11";
      flake = false;
    };
    nixpkgs-py39 = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
      flake = false;
    };
    nixpkgs-py310 = {
      url = "github:NixOS/nixpkgs/nixos-25.11";
      flake = false;
    };

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
