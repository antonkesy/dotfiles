{
  description = "antonkesy home (Home Manager, any Linux distro)";

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
      # home-manager switch --flake .#ak (Arch, WSL)
      homeConfigurations.ak = mkHome;

      packages.${system} = {
        # First run on a machine without home-manager in PATH:
        #   nix run .#home-manager -- switch --flake .#ak
        inherit (home-manager.packages.${system}) home-manager;
        default = home-manager.packages.${system}.home-manager;
      };

      formatter.${system} = pkgs.nixfmt-tree;

      # `nix flake check` builds the activation package; CI only evaluates and
      # dry-builds (see .github/workflows/nix.yml).
      checks.${system}.ak = self.homeConfigurations.ak.activationPackage;
    };
}
