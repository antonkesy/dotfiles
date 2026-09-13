# git with signed commits, plus the gpg agent that makes signing work.
{ lib, pkgs, ... }:
{
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    # Terminal default; ../setup's NixOS desktop module overrides this with
    # pinentry-gnome3 where there is a session.
    pinentry.package = lib.mkDefault pkgs.pinentry-curses;
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
