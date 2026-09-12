# GUI applications. Everything that came from the AUR is either a nixpkgs
# package or a derivation in pkgs/. On non-NixOS these get OpenGL through
# targets.genericLinux.gpu (options.nix). Steam, waydroid, ollama and
# gpu-screen-recorder need system integration and live in ../setup.
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
    qutebrowser

    # --- editors / IDEs ---
    vscode
    code-cursor # AUR cursor-bin
    unityhub
    godot_4

    # --- graphics ---
    gimp
    krita
    pinta
    blender
    drawio
    flameshot
    obs-studio

    # --- documents ---
    kdePackages.okular
    evince
    xournalpp
    pdftk
    pdfarranger
    pympress
    zotero
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
    remmina
    nextcloud-client
    baobab
    appstream-glib

    # --- ai --- (ollama is a system service, see ../setup)
    lmstudio

    # --- api / dev ---
    postman

    # --- robotics / automotive / annotation (all from pkgs/) ---
    webots
    screenpen
    dbc-utility

    # --- toolkits several of the above dlopen at runtime ---
    qt5.qtbase
    qt6.qtbase
    libtiff
  ];
}
