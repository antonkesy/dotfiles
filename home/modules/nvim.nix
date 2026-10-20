{ pkgs, config, ... }:
let
  liveCheckout = config.lib.file.mkOutOfStoreSymlink "${config.ak.dotfilesDir}/home/.config/nvim";
in
{
  home.packages = with pkgs; [
    # compilers, rg, fd and node for plugins come from development.nix and terminal.nix
    neovim
    gettext
    tree-sitter
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  xdg.configFile."nvim".source = liveCheckout;
}
