# nixpkgs.config shared by the standalone Home Manager flake here and by the
# NixOS flake in ../setup (which imports it as inputs.dotfiles.lib.nixpkgsConfig
# because home-manager.useGlobalPkgs ignores nixpkgs.* set inside HM modules).
{
  allowUnfree = true;
  # dotnet SDK 6 and 7 are past end of life and nixpkgs marks them insecure.
  # Drop these (and sdk_6_0/sdk_7_0 in modules/home/development.nix) when the
  # projects that need them are gone.
  permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-7.0.410"
    "dotnet-sdk-wrapped-6.0.428"
    "dotnet-sdk-wrapped-7.0.410"
  ];
}
