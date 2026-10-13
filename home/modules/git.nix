{ config, pkgs, ... }:
let
  # WSL has no gcr prompter, so pinentry-gnome3 falls back to curses over whatever TUI
  # asked; WSLg shows a qt window instead. The agent's env has no DISPLAY: default it
  pinentry-auto = pkgs.writeShellScriptBin "pinentry-auto" ''
    if [ -d /mnt/wslg ]; then
      export DISPLAY="''${DISPLAY:-:0}" QT_QPA_PLATFORM=xcb
      exec ${pkgs.pinentry-qt}/bin/pinentry-qt "$@"
    fi
    exec ${pkgs.pinentry-gnome3}/bin/pinentry-gnome3 "$@"
  '';
in
{
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    # prompts in its own window, never over a TUI; curses fallback without a prompter
    pinentry.package = pinentry-auto;
    # unlock once per agent lifetime (400 days)
    defaultCacheTtl = 34560000;
    maxCacheTtl = 34560000;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "Anton Kesy";
        email = "anton@kesy.de";
        signingkey = "756091A5C7C181AE4DF5EF42EEFE6D18C482C483";
      };
      core.editor = "nvim";
      init.defaultBranch = "main";
      help.autocorrect = 10;
      pull.rebase = true;
      commit.gpgsign = true;
      bash = {
        showDirtyState = true;
        showUntrackedFiles = true;
      };
    };
    # per-machine, untracked
    includes = [ { path = "${config.xdg.configHome}/git/local"; } ];
  };

  home.packages = with pkgs; [ gh ];
}
