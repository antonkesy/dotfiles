# Replaces tasks/editors/neovim.yml, which built neovim from source into
# /usr/local and cloned the config via stow.
{
  pkgs,
  config,
  inputs,
  hostName,
  ...
}:
let
  # On a real machine the config is the git submodule in this repo, symlinked
  # out of the store so lazy.nvim can write lock files and spell downloads into
  # it and so edits take effect without a rebuild.
  #
  # The demo VM has no checkout, and a gitlink's contents never reach the flake
  # store copy, so it gets the pinned nvim-config input instead. Read-only there,
  # which is fine for a demo but would break `:Lazy update` on a real host.
  liveCheckout = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/workspace/dotfiles/home/.config/nvim";
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

  xdg.configFile."nvim".source = if hostName == "demo" then inputs.nvim-config else liveCheckout;
}
