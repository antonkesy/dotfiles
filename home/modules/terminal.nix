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
    tealdeer
    fastfetch
    codespell
    shellcheck
    tree
    act
    just
    trash-cli
    libzint
    claude-code
    codex

    # --- python ---
    gdown
    yt-dlp
    pre-commit
    python3Packages.shtab

    # --- terminal ---
    tmux
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
