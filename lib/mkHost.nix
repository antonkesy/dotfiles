# mkHost "name" [ ./hosts/name ] -> nixosSystem with Home Manager wired in.
inputs: hostName: extraModules:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs hostName; };
  modules = [
    ../hosts/common.nix
    inputs.home-manager.nixosModules.home-manager
    {
      networking.hostName = hostName;
      nixpkgs.overlays = [ (import ../pkgs) ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs hostName; };
        users.ak = import ../modules/home;
        # Move pre-existing files aside instead of failing the activation.
        backupFileExtension = "hm-bak";
      };
    }
  ]
  ++ extraModules;
}
