{
  description = "antonkesy Home Manager configuration (any Linux distro)";

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
      inherit (nixpkgs) lib;

      nixpkgsConfig = import ./lib/nixpkgs-config.nix;
      pkgs = import nixpkgs {
        inherit system;
        config = nixpkgsConfig;
        overlays = [ self.overlays.default ];
      };

      mkHome = import ./lib/mkHome.nix { inherit inputs pkgs; };

      # One entry per hosts/<name>.nix. akdesk/aklap are NixOS machines whose
      # system half lives in ../setup; ak is a generic non-NixOS desktop; wsl
      # is terminal-only.
      hosts = [
        "akdesk"
        "aklap"
        "ak"
        "wsl"
      ];
    in
    {
      overlays.default = import ./pkgs;

      # Consumed by ../setup's NixOS flake: nixpkgs.config must be identical on
      # both sides (useGlobalPkgs), and mkHome for anyone wanting to reuse it.
      lib = { inherit nixpkgsConfig mkHome; };

      # default = all modules with every flag off; <host> = that host's flags.
      # ../setup imports both into home-manager.users.ak.
      homeModules = {
        default = ./modules/home;
      }
      // lib.genAttrs hosts (h: ./hosts + "/${h}.nix");

      # home-manager switch --flake .#<host>
      homeConfigurations = lib.genAttrs hosts mkHome;

      packages.${system} = {
        # First run on a machine without home-manager in PATH:
        #   nix run .#home-manager -- switch --flake .#<host>
        inherit (home-manager.packages.${system}) home-manager;
        default = home-manager.packages.${system}.home-manager;
      };

      formatter.${system} = pkgs.nixfmt-tree;

      # `nix flake check` builds every host's activation package; CI only
      # evaluates (see .github/workflows/nix.yml).
      checks.${system} = lib.mapAttrs (_: c: c.activationPackage) self.homeConfigurations;
    };
}
