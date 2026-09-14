{ pkgs, ... }:
{
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    # prompts in its own window, never over a TUI; curses fallback without a prompter
    pinentry.package = pkgs.pinentry-gnome3;
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
  };

  home.packages = with pkgs; [ gh ];
}
