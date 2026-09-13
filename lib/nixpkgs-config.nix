# nixpkgs.config for the Home Manager flake (kept out of the modules so they
# never set nixpkgs.* themselves, see lib/mkHome.nix).
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
