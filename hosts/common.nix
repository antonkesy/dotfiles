{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ../modules/nixos/base.nix
    ../modules/nixos/networking.nix
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nixpkgs.config.allowUnfree = true;
  # The old playbook installed dotnet SDK 6 and 7; both are past end of life and
  # nixpkgs marks them insecure. Kept for parity — drop these two entries (and
  # the matching sdk_6_0/sdk_7_0 in modules/nixos/development.nix) when the
  # projects that need them are gone.
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-7.0.410"
    "dotnet-sdk-wrapped-6.0.428"
    "dotnet-sdk-wrapped-7.0.410"
  ];

  # Replaces `timedatectl set-timezone` from tasks/core/base.yml.
  time.timeZone = "Europe/Berlin";
  # mkDefault: the qemu-vm profile turns this off for the demo VM.
  services.timesyncd.enable = lib.mkDefault true;

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  users.users.ak = {
    isNormalUser = true;
    description = "Anton Kesy";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
      "dialout" # arduino / serial
    ];
  };
  users.defaultUserShell = pkgs.zsh;

  security.sudo.wheelNeedsPassword = lib.mkDefault true;

  # tasks/desktop/core.yml wrote /etc/security/faillock.conf with deny = 0.
  security.pam.services.login.failDelay.enable = false;
  environment.etc."security/faillock.conf".text = "deny = 0\n";

  # gnome-keyring + ssh-agent, replacing tasks/core/keyring.yml (which hand-edited
  # /etc/pam.d/login and wrote a user unit for ssh-agent).
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  # The README documents gcr-ssh-agent spinning at 99% CPU; use the plain agent,
  # which is also what home/.config/zsh/path.zsh points SSH_AUTH_SOCK at.
  services.gnome.gcr-ssh-agent.enable = false;
  programs.ssh.startAgent = true;

  system.stateVersion = "25.11";
}
