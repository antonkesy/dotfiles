# git with signed commits + the gpg agent behind it.
{ pkgs, ... }:
{
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    # Not the ssh-agent: gnome-keyring's gcr-ssh-agent is (desktop.nix).
    enableSshSupport = false;
    # Prompts through gcr's system prompter, a window of its own, so a TUI
    # (lazygit) is never drawn over. The dialog has "Save in password manager":
    # gpg-agent's allow-external-cache (default on) lets pinentry keep the
    # passphrase in the login keyring and fetch it silently from then on, so
    # the agent's own cache ttl no longer matters. Without a prompter (WSL,
    # tty) it falls back to curses.
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
