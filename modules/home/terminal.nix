# Replaces tasks/terminal/{terminal,alacritty,cli}.yml. Everything that used to
# come from `cargo install`, `go install`, `pipx install` or the AUR is a plain
# nixpkgs package here.
{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      general.import = [ "${pkgs.alacritty-theme}/iterm.toml" ];
      window = {
        decorations = "None";
        padding = {
          x = 0;
          y = 0;
        };
        opacity = 1.0;
      };
      scrolling.history = 50000;
      font = {
        normal = {
          family = "Hack Nerd Font Mono";
          style = "Regular";
        };
        size = 12;
      };
      terminal.osc52 = "CopyPaste";
      mouse.hide_when_typing = true;
      selection.save_to_clipboard = false;
      cursor = {
        style = {
          shape = "Block";
          blinking = "On";
        };
        blink_interval = 500;
        unfocused_hollow = true;
      };
      bell.duration = 0;
      keyboard.bindings = [
        {
          key = "Space";
          mods = "Control";
          action = "ToggleViMode";
        }
        {
          key = "Y";
          mode = "Vi";
          action = "Copy";
        }
        {
          key = "Return";
          mods = "Shift";
          chars = "\r";
        }
      ];
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git.overrideGpg = true;
      disableStartupPopups = true;
    };
  };

  programs.bat.enable = true;
  programs.eza.enable = true;
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
  };

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
    lazydocker

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
    python3Packages.libtmux
    jupyter

    # --- terminal ---
    tmux
    fzf
    xsel
    wl-clipboard
    atop
    btop
  ];
}
