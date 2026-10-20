{
  allowUnfree = true;
  # EOL dotnet SDKs (development.nix)
  # by name, so a nixpkgs bump of the patch version does not break evaluation
  allowInsecurePredicate =
    p:
    builtins.elem (p.pname or "") [
      "dotnet-sdk"
      "dotnet-sdk-wrapped"
    ];
}
