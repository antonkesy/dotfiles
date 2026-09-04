# Replaces tasks/desktop/apps.yml, tasks/editors/{vscode,unity}.yml and
# tasks/development/webots.yml. Everything that came from the AUR is either a
# nixpkgs package or a derivation in pkgs/.
{ pkgs, ... }:
{
  programs.firefox.enable = true;
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
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
    gpu-screen-recorder

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

    # --- ai --- (ollama comes from services.ollama below)
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

  # tasks/desktop/apps.yml enabled waydroid but never installed it.
  virtualisation.waydroid.enable = true;

  # tasks/ai/ollama.yml. CPU build by default; nvidia.nix swaps in ollama-cuda.
  services.ollama.enable = true;
}
