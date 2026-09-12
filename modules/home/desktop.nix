# Wayland helper tools and desktop odds and ends that do not need root. The
# compositor stack itself -- Hyprland, hyprlock/hypridle, uwsm, portals,
# DankMaterialShell (which brings the polkit agent), pipewire, greetd, GL
# drivers -- comes from the system (../setup: NixOS modules or the ansible
# desktop role).
{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.ak.desktop.enable {
  home.packages = with pkgs; [
    # --- hyprland ecosystem ---
    bibata-cursors
    wlogout
    awww # upstream renamed swww -> awww
    wayscriber
    better-control
    dsearch
    cliphist
    wl-clipboard
    grim
    slurp
    brightnessctl
    pamixer
    playerctl
    dunst
    waybar
    wofi
    tofi
    rofi
    dmenu
    kitty
    nautilus
    adwaita-icon-theme
    gnome-themes-extra
    kdePackages.dolphin
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
    xdg-utils

    # --- keyring / audio / bluetooth / webcam frontends ---
    libsecret
    seahorse
    pavucontrol
    alsa-utils
    bluetui
    guvcview
    v4l-utils
    libva-utils # vainfo
  ];

  # Ubuntu theme on nautilus
  home.sessionVariables.GTK_THEME = "Adwaita";

  # GTK apps follow the dark scheme (was setup/manual/dark-mode.sh: gsettings).
  # Needs the dconf service: programs.dconf on NixOS, the dconf package on Arch.
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  # On NixOS ../setup runs the keyring via PAM (services.gnome.gnome-keyring).
  # Standalone, a user unit; no "ssh" component so it never competes with
  # services.ssh-agent (base.nix).
  services.gnome-keyring = {
    enable = !config.ak.nixos;
    components = [
      "pkcs11"
      "secrets"
    ];
  };
}
