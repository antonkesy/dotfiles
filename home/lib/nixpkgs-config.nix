{
  allowUnfree = true;
  # EOL dotnet SDKs (development.nix)
  permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-7.0.410"
    "dotnet-sdk-wrapped-6.0.428"
    "dotnet-sdk-wrapped-7.0.410"
  ];
}
