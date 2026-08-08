# Replaces tasks/editors/neovim.yml, which built neovim from source into
# /usr/local and cloned the config via stow.
{ pkgs, config, ... }:
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
    nodejs # several LSP servers are npm packages
  ];

  home.sessionVariables.EDITOR = "nvim";

  # Out-of-store symlink to the live git submodule: lazy.nvim writes lock files
  # and downloads spellfiles inside this tree, so it has to stay writable.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/workspace/dotfiles/home/.config/nvim";
}
