# git with signed commits + the gpg agent behind it.
{ lib, pkgs, ... }:
{
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    # -tty, not -curses: prompts inline on the terminal like sudo does.
    # pinentry-curses draws a full-screen dialog box over the session.
    pinentry.package = lib.mkDefault pkgs.pinentry-tty;
    # pam_gnupg (desktop role) presets the passphrase at login. A preset is
    # still a cache entry, so it dies with max-cache-ttl -- keep both a full
    # day so one login lasts the session. Expiry only costs an inline prompt.
    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;
    # required for gpg-preset-passphrase, which is how pam_gnupg feeds the key
    extraConfig = "allow-preset-passphrase\n";
  };

  # Keygrips pam_gnupg unlocks at login -- `gpg -K --with-keygrip`, not the key
  # id. This is the keygrip of user.signingkey above.
  home.file.".pam-gnupg".text = ''
    B86443082B4A0C8F79160792E7063BF1F96F9DDA
  '';

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
