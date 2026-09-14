# The Hyprland + DankMaterialShell config under home/.config, and the
# user-level session bits that go with it. No packages: the compositor, DMS
# and every GUI app come from the distro via system/Arch's ansible. Applied on
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
#
# Plus one systemd enablement symlink (graphical-session.target.wants/dms.service):
# DMS autostart, replacing the `dms run` that hyprland.lua used to exec.
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
  xdg.configFile =
    lib.genAttrs linked (rel: {
      source = link rel;
    })
    // {
      # Exactly what `systemctl --user enable dms.service` writes. The unit body
      # stays the distro's (dms-shell ships /usr/lib/systemd/user/dms.service);
      # only the enablement is ours. It is WantedBy=graphical-session.target,
      # which uwsm activates -- hence the uwsm session entry in system/Arch.
      # mkOutOfStoreSymlink rather than a path literal: nothing under /usr is read
      # at eval time, so this still evaluates on WSL and in CI, where dms-shell is
      # not installed.
      "systemd/user/graphical-session.target.wants/dms.service".source =
        config.lib.file.mkOutOfStoreSymlink "/usr/lib/systemd/user/dms.service";
    };

  home.activation.seedMutableConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.concatStringsSep "\n" (lib.mapAttrsToList seed seeds)
  );

  # environment.d, read by the systemd user manager and therefore by uwsm,
  # Hyprland and every user unit. dms.service is started by systemd now, so
  # anything DMS needs belongs here: hl.env() in hyprland.lua only reaches
  # Hyprland's own children.
  systemd.user.sessionVariables = {
    GTK_THEME = "Adwaita"; # Ubuntu theme on nautilus
    DMS_DISABLE_MATUGEN = "1"; # no theme generation from dms
  };

  # GTK apps follow the dark scheme.
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  # flutter web; google-chrome comes from the AUR via system/Arch.
  home.sessionVariables.CHROME_EXECUTABLE = "/usr/bin/google-chrome-stable";
}
