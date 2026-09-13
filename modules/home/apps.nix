{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.ak.desktop.enable {
  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox"; # keep the pre-26.05 profile location
  };

  home.packages = with pkgs; [
    # --- browsers ---
    google-chrome

    # --- editors / IDEs ---
    vscode
    godot_4

    # --- graphics ---
    gimp
    pinta
    blender
    drawio
    obs-studio

    # --- documents ---
    kdePackages.okular
    evince # PDF Viewer
    pdfarranger
    pympress
    wpsoffice
    anki

    # --- media ---
    vlc
    amberol

    # --- communication ---
    thunderbird
    discord
    teams-for-linux

    # --- system / network ---
    mission-center
    remmina # Remote Desktop
    nextcloud-client
    baobab # Disk Usage Analyser

    # --- annotation ---
    screenpen # draw on screen

    # --- toolkits several of the above dlopen at runtime ---
    qt5.qtbase
    qt6.qtbase
    libtiff
  ];
}
