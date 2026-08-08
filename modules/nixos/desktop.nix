# Replaces tasks/desktop/{hyprland,dankshell,gnome,core,font}.yml.
{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.dank-material-shell.nixosModules.dank-material-shell ];

  # --- compositor ---------------------------------------------------------
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };

  # --- DankMaterialShell --------------------------------------------------
  # settings/session are deliberately left unset: the module then emits no
  # xdg.configFile for them and DMS keeps owning ~/.config/DankMaterialShell/*.json
  # and ~/.config/hypr/dms/{colors,outputs,cursor,layout}.lua as real writable
  # files. Declaring them would make DMS unable to persist anything.
  programs.dank-material-shell = {
    enable = true;
    # No systemd unit: hyprland.lua's `hyprland.start` hook already execs
    # `dms run`, and that path wins — the unit would just sit inactive.
    systemd.enable = false;
    enableSystemMonitoring = true;
    enableVPN = true;
    enableCalendarEvents = true;
    enableClipboardPaste = true;
    # hyprland.lua sets DMS_DISABLE_MATUGEN=1, so no dynamic theming.
    enableDynamicTheming = false;
    enableAudioWavelength = true;
  };
  # ponytail: ~/.config/DankMaterialShell/plugins/ stays unmanaged — DMS clones
  # plugins there itself (see the .repos dir). Declare plugins here only if you
  # want them pinned in the store.

  # --- GNOME ---------------------------------------------------------------
  # Kept from tasks/desktop/gnome.yml: gdm offers both a GNOME and a Hyprland
  # session, which is the README's "Gnome Online Accounts on Hyprland" workaround.
  services.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "hyprland-uwsm";
  services.desktopManager.gnome.enable = true;

  # --- audio ---------------------------------------------------------------
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # --- printing / misc services -------------------------------------------
  services.printing = {
    enable = true;
    drivers = with pkgs; [ cups-pdf-to-pdf ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  programs.dconf.enable = true;
  security.polkit.enable = true;
  security.rtkit.enable = true;

  # --- fonts ---------------------------------------------------------------
  fonts = {
    enableDefaultPackages = true;
    fontconfig.enable = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-cove
      nerd-fonts.caskaydia-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term
      nerd-fonts.symbols-only
      jetbrains-mono
      fira-code
      fira-mono
      fira-sans
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      liberation_ttf # also covers ttf-croscore (metric-compatible)
      dejavu_fonts
      ubuntu-classic
      corefonts # ttf-ms-fonts (unfree)
    ];
  };

  environment.systemPackages = with pkgs; [
    # --- hyprland ecosystem ---
    hypridle
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
    kdePackages.dolphin
    kdePackages.polkit-kde-agent-1
    kdePackages.kwallet
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
    qt5.qtwayland
    qt6.qtwayland

    # --- gnome extras from tasks/desktop/gnome.yml ---
    gnome-tweaks
    gnome-calculator
    gnome-system-monitor
    gnome-disk-utility
    gnome-font-viewer
    gnome-calendar
    baobab
    file-roller
    sushi
    simple-scan
    evince
    evolution
    evolution-ews

    # --- gstreamer codecs from tasks/desktop/core.yml ---
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly

    # --- keyring ---
    gnome-keyring
    libsecret
    seahorse
  ];
}
