# Replaces tasks/editors/neovim.yml, which built neovim from source into
# /usr/local and cloned the config via stow.
{ pkgs, config, ... }:
let
  # On a real machine the config is the git submodule in this repo, symlinked
  # out of the store so lazy.nvim can write lock files and spell downloads into
  # it and so edits take effect without a rebuild.
  liveCheckout = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/dotfiles/home/.config/nvim";
in
{
  home.packages = with pkgs; [
    neovim
    # Build deps LazyVim's treesitter/telescope compile steps still want.
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
