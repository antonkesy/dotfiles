# Hyprland + DMS config; packages come from system/Arch.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  dotfiles = "${config.ak.dotfilesDir}/home/.config";
  link = rel: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${rel}";

  # ~/.config/hypr stays a real dir (DMS drops .dms-backups/ there)
  linked = [
    "hypr/hyprland.lua"
    "hypr/plugins.lua"
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

  # copy-once, the app rewrites them
  seeds = {
    "discord/settings.json" = ''
      { "SKIP_HOST_UPDATE": true }
    '';
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
  xdg.configFile = lib.genAttrs linked (rel: {
    source = link rel;
  });

  # units ship with the Arch packages; skipped where absent (WSL)
  home.activation.enableSystemUnits = lib.hm.dag.entryAfter [ "reloadSystemd" ] ''
    for unit in dms.service gcr-ssh-agent.socket; do
      if [ -e "/usr/lib/systemd/user/$unit" ]; then
        run /usr/bin/systemctl --user enable "$unit"
      fi
    done
  '';

  home.activation.seedMutableConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.concatStringsSep "\n" (lib.mapAttrsToList seed seeds)
  );

  # plugins/ is gitignored; plugins.lock.json pins them
  home.activation.restoreDmsPlugins = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    dms_dir="${config.xdg.configHome}/DankMaterialShell"
    if [ -x /usr/bin/dms ] && [ -f "$dms_dir/plugins.lock.json" ]; then
      for id in $(${pkgs.jq}/bin/jq -r '.plugins | keys[]' "$dms_dir/plugins.lock.json"); do
        if [ ! -d "$dms_dir/plugins/$id" ]; then
          run /usr/bin/dms plugins restore "$dms_dir/plugins.lock.json" || true
          break
        fi
      done
    fi
  '';

  # environment.d, reaches dms.service
  systemd.user.sessionVariables = {
    GTK_THEME = "Adwaita";
    DMS_DISABLE_MATUGEN = "1";
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  # flutter web
  home.sessionVariables.CHROME_EXECUTABLE = "/usr/bin/google-chrome-stable";
}
