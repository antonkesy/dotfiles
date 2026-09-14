{ pkgs, config, ... }:
let
  # out-of-store so lazy.nvim can write lock files and spell downloads
  liveCheckout = config.lib.file.mkOutOfStoreSymlink "${config.ak.dotfilesDir}/home/.config/nvim";
in
{
  home.packages = with pkgs; [
    neovim
    # build deps for treesitter/telescope
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
    nodejs # several LSP servers are npm packages
  ];

  home.sessionVariables.EDITOR = "nvim";

  xdg.configFile."nvim".source = liveCheckout;
}
