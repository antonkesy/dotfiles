# Hyprland + DMS config. Packages come from system/Arch.
# DMS rewrites its own config and invents files as it goes, so its two dirs are
# linked whole and their .gitignore keeps the machine-local ones out. ~/.config/hypr
# itself stays a real dir (DMS drops .dms-backups/ there); seeds are copy-once.
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
    # whole dirs: DMS owns binds/colors/layout/windowrules, writes binds-user
    # from its settings GUI, and adds files per machine and per version
    "hypr/dms"
    "DankMaterialShell"
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

  seeds = {
    # discord rewrites this itself
    "discord/settings.json" = ''
      { "SKIP_HOST_UPDATE": true }
    '';
    # marker: skip the DMS onboarding wizard; lands in the checkout, gitignored
    "DankMaterialShell/.firstlaunch" = "";
  };

  seed =
    rel: content:
    let
      target = "${config.xdg.configHome}/${rel}";
      src = pkgs.writeText (baseNameOf rel) content;
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
      # `systemctl --user enable dms.service`, declaratively. Out-of-store so
      # /usr is not read at eval time (WSL, CI).
      "systemd/user/graphical-session.target.wants/dms.service".source =
        config.lib.file.mkOutOfStoreSymlink "/usr/lib/systemd/user/dms.service";
    };

  home.activation.seedMutableConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.concatStringsSep "\n" (lib.mapAttrsToList seed seeds)
  );

  # environment.d; dms.service needs these, hl.env() would not reach it
  systemd.user.sessionVariables = {
    GTK_THEME = "Adwaita";
    DMS_DISABLE_MATUGEN = "1";
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  # flutter web
  home.sessionVariables.CHROME_EXECUTABLE = "/usr/bin/google-chrome-stable";
}
