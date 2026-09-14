# CLI/TUI tools. Their configs are the dotfiles under home/, linked by
# dotfiles.nix, not programs.* options.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # --- rust ---
    ripgrep
    fd
    procs
    bottom
    dysk
    typos
    lychee

    # --- go ---
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

    # --- python ---
    gdown
    yt-dlp
    pre-commit
    python3Packages.shtab
    # jupyter: jupyterlab/notebook live in the python env of development.nix

    # --- terminal ---
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
