# Replaces tasks/terminal/{terminal,alacritty,cli}.yml. Everything that used to
# come from `cargo install`, `go install`, `pipx install` or the AUR is a plain
# nixpkgs package here. The configs (alacritty.toml, lazygit/config.yml,
# .tmux.conf, .zshrc + zsh fragments) are the dotfiles under home/, linked by
# modules/home/dotfiles.nix -- not programs.* options.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # --- replacements for the cargo-installed tools ---
    ripgrep
    fd
    procs
    bottom
    dysk
    typos
    lychee

    # --- go install -> nixpkgs ---
    lazygit

    # --- cli ---
    jq
    yq-go
    tealdeer # what Arch's `tldr` actually is
    fastfetch
    codespell
    tree
    act
    just
    trash-cli
    libzint # `zint` throws on eval; this ships the CLI
    claude-code

    # --- pipx -> nixpkgs ---
    gdown
    yt-dlp
    pre-commit
    python3Packages.shtab
    # jupyter: jupyterlab/notebook live in the python env of development.nix

    # --- terminal ---
    alacritty
    tmux # plugins come from tpm (home/.tmux.conf)
    zsh
    fzf
    atuin
    zoxide
    bat
    eza
    yazi
    xsel
    wl-clipboard
    atop
    btop
  ];
}
