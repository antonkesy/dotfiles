# git with signed commits + the gpg agent behind it, which is also the ssh-agent.
{ lib, pkgs, ... }:
let
  # Keygrip of user.signingkey below -- `gpg -K --with-keygrip`, not the key id.
  signingKeygrip = "B86443082B4A0C8F79160792E7063BF1F96F9DDA";

  # pam_gnupg (desktop role) presets the passphrase of every keygrip listed in
  # ~/.pam-gnupg at login. Written instead of a static home.file because the
  # ssh keygrips are only known once a key has been handed to the agent:
  # sshcontrol is gpg-agent's own list of the ssh keys it holds, so `ssh-add`
  # plus the next `make home` is all a new key needs.
  writePamGnupg = pkgs.writeShellScript "write-pam-gnupg" ''
    # it was a home.file symlink into the read-only store until 2026-09
    rm -f "$HOME/.pam-gnupg"
    {
      echo "${signingKeygrip}"
      grep -oE '^[0-9A-Fa-f]{40}' "$HOME/.gnupg/sshcontrol" 2>/dev/null || true
    } >"$HOME/.pam-gnupg"
  '';
in
{
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    # gpg-agent is the ssh-agent too (base.nix starts none): one agent, one
    # pinentry, and the single pam_gnupg preset at login covers both. A key
    # joins it once with `ssh-add ~/.ssh/<key>`, which re-encrypts it into
    # ~/.gnupg/private-keys-v1.d -- give it the login password at that prompt,
    # that is the passphrase pam replays. SSH_AUTH_SOCK has to name the agent
    # socket; programs.zsh is unused here, so zsh/path.zsh and hyprland.lua do.
    enableSshSupport = true;
    # -tty, not -curses: prompts inline on the terminal like sudo does.
    # pinentry-curses draws a full-screen dialog box over the session.
    pinentry.package = lib.mkDefault pkgs.pinentry-tty;
    # pam_gnupg (desktop role) presets the passphrase at login. A preset is
    # still a cache entry, so it dies with max-cache-ttl -- keep both a full
    # day so one login lasts the session. Expiry only costs an inline prompt.
    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;
    # ssh keys are cached under their own ttls, which are far shorter (30min
    # by default) and would expire the preset mid-day.
    defaultCacheTtlSsh = 86400;
    maxCacheTtlSsh = 86400;
    # required for gpg-preset-passphrase, which is how pam_gnupg feeds the key
    extraConfig = "allow-preset-passphrase\n";
  };

  home.activation.pamGnupgKeygrips = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run --silence ${writePamGnupg}
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
