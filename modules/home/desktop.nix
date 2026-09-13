# The Hyprland + DankMaterialShell config under home/.config, and the
# user-level session bits that go with it. No packages: the compositor, DMS
# and every GUI app come from the distro via ../setup's ansible. Applied on
# every machine (WSL too, where it is simply unused) so that all of ~ comes
# from one place.
#
# Three tiers, because DankMaterialShell rewrites its own config at runtime:
#   linked  - out-of-store symlinks into the checkout (edits apply with
#             `hyprctl reload`). ~/.config/hypr is linked file by file on
#             purpose: the directory must stay a real, writable one so DMS can
#             generate colors/outputs/layout/cursor/binds.lua next to the
#             hand-written files.
#   seeded  - copied once when absent, then owned by DMS/discord. Live state
#             always wins; delete the file and switch again to re-apply the
#             repo version.
#   left alone - machine-specific state (DankMaterialShell/monitors.json,
#             hypr/dms/{outputs,cursor}.lua, hypr/dms/profiles/), gitignored
#             under home/.config and never declared here.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  dotfiles = "${config.ak.dotfilesDir}/home/.config";
  link = rel: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${rel}";

  linked = [
    "hypr/hyprland.lua"
    "hypr/plugins.lua"
    "hypr/dms/binds-user.lua"
    "hypr/dms/windowrules.lua"
    "wallpapers"
  ]
  ++ map (s: "hypr/scripts/${s}.sh") [
    "calendar"
    "discord-scratchpad"
    "kill-menu"
    "mail-scratchpad"
    "music"
    "task-manager-scratchpad"
  ];

  # rel under ~/.config -> source: null = the same rel in the checkout,
  # otherwise the literal content.
  seeds = {
    "DankMaterialShell/settings.json" = null;
    "DankMaterialShell/clsettings.json" = null;
    "DankMaterialShell/plugin_settings.json" = null;
    "hypr/dms/binds.lua" = null;
    "hypr/dms/colors.lua" = null;
    "hypr/dms/layout.lua" = null;
    # Discord rewrites the file itself (window geometry etc.).
    "discord/settings.json" = ''
      { "SKIP_HOST_UPDATE": true }
    '';
    # Zero-byte marker: skips the DMS onboarding wizard that would otherwise
    # sit in front of the seeded settings.
    "DankMaterialShell/.firstlaunch" = "";
  };

  seed =
    rel: content:
    let
      target = "${config.xdg.configHome}/${rel}";
      src = if content == null then "${dotfiles}/${rel}" else pkgs.writeText (baseNameOf rel) content;
    in
    ''
      if [ ! -e "${target}" ]; then
        run mkdir -p "$(dirname "${target}")"
        run install -m644 "${src}" "${target}"
      fi
    '';
in
{
  xdg.configFile = lib.genAttrs linked (rel: {
    source = link rel;
  });

  home.activation.seedMutableConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.concatStringsSep "\n" (lib.mapAttrsToList seed seeds)
  );

  # Ubuntu theme on nautilus; environment.d is what uwsm/Hyprland read.
  systemd.user.sessionVariables.GTK_THEME = "Adwaita";

  # GTK apps follow the dark scheme.
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  # flutter web; google-chrome comes from the AUR via ../setup.
  home.sessionVariables.CHROME_EXECUTABLE = "/usr/bin/google-chrome-stable";
}
