{ pkgs, config, ... }:
let
  liveCheckout = config.lib.file.mkOutOfStoreSymlink "${config.ak.dotfilesDir}/home/.config/nvim";
in
{
  home.packages = with pkgs; [
    neovim
    gcc
    gnumake
    cmake
    ninja
    gettext
    unzip
    curl
    tree-sitter
    ripgrep
    fd
    nodejs
  ];

  home.sessionVariables.EDITOR = "nvim";

  xdg.configFile."nvim".source = liveCheckout;
}
