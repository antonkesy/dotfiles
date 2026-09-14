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
    tree
    act
    just
    trash-cli
    libzint
    claude-code

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
