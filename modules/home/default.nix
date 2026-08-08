{ lib, ... }:
{
  imports = [
    ./zsh.nix
    ./tmux.nix
    ./terminal.nix
    ./hyprland.nix
    ./nvim.nix
    ./git.nix
  ];

  home.username = "ak";
  home.homeDirectory = "/home/ak";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
  xdg.enable = true;

  # tasks/desktop/apps.yml wrote SKIP_HOST_UPDATE into discord's settings.json.
  # Seeded rather than symlinked: discord rewrites this file itself (window
  # geometry etc.) and a read-only store path would break it.
  home.activation.seedDiscordSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e "$HOME/.config/discord/settings.json" ]; then
      run mkdir -p "$HOME/.config/discord"
      run echo '{ "SKIP_HOST_UPDATE": true }' > "$HOME/.config/discord/settings.json"
    fi
  '';
}
