# Config that has to start from the repo but must stay writable afterwards.
#
# DankMaterialShell rewrites its own settings at runtime — theme, bar layout,
# keybinds, plugin state — so these paths cannot be xdg.configFile store
# symlinks (see modules/home/dotfiles.nix for the half that can). Seeding gives
# a fresh machine the real settings while leaving DMS able to persist changes.
#
# Seeds are only written when the target is absent, so live DMS state always
# wins over the repo copy. To re-apply an updated repo version on a machine that
# already has one, delete the file and switch again.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Everything tracked in git under these two directories. The repo's own
  # .gitignore files already draw the line: machine-specific state
  # (monitors.json, outputs.lua, cursor.lua, profiles/) is ignored and is
  # deliberately absent here.
  seeds = {
    "DankMaterialShell/settings.json" = ../../home/.config/DankMaterialShell/settings.json;
    "DankMaterialShell/clsettings.json" = ../../home/.config/DankMaterialShell/clsettings.json;
    "DankMaterialShell/plugin_settings.json" =
      ../../home/.config/DankMaterialShell/plugin_settings.json;

    "hypr/dms/binds.lua" = ../../home/.config/hypr/dms/binds.lua;
    "hypr/dms/colors.lua" = ../../home/.config/hypr/dms/colors.lua;
    "hypr/dms/layout.lua" = ../../home/.config/hypr/dms/layout.lua;

    # tasks/desktop/apps.yml used to write this by hand. Discord rewrites the
    # file itself (window geometry etc.), so it is seeded, not linked.
    "discord/settings.json" = pkgs.writeText "discord-settings.json" ''
      { "SKIP_HOST_UPDATE": true }
    '';
  };

  # Zero-byte markers. Creating .firstlaunch up front skips the DMS onboarding
  # wizard, which would otherwise sit in front of the seeded settings.
  markers = [ "DankMaterialShell/.firstlaunch" ];

  seedFile = rel: src: ''
    if [ ! -e "${config.xdg.configHome}/${rel}" ]; then
      run mkdir -p "$(dirname "${config.xdg.configHome}/${rel}")"
      run install -m644 ${src} "${config.xdg.configHome}/${rel}"
    fi
  '';

  touchMarker = rel: ''
    if [ ! -e "${config.xdg.configHome}/${rel}" ]; then
      run mkdir -p "$(dirname "${config.xdg.configHome}/${rel}")"
      run touch "${config.xdg.configHome}/${rel}"
    fi
  '';
in
# All of these belong to the Hyprland/DMS desktop; nothing to seed on wsl.
lib.mkIf config.ak.desktop.enable {
  home.activation.seedMutableConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.concatStringsSep "\n" (lib.mapAttrsToList seedFile seeds ++ map touchMarker markers)
  );
}
