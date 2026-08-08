# Deploys the authored half of ~/.config/hypr. Replaces the `stow --adopt` in
# tasks/misc/dotfiles.yml.
#
# The split matters: xdg.configFile."hypr/x.lua" symlinks a single file and
# leaves ~/.config/hypr and ~/.config/hypr/dms as real writable directories, so
# DankMaterialShell can keep generating colors/outputs/layout/cursor/binds.lua
# next to them. Symlinking the whole directory would make DMS unable to persist.
{ lib, ... }:
let
  scripts = [
    "calendar"
    "discord-scratchpad"
    "kill-menu"
    "mail-scratchpad"
    "music"
    "task-manager-scratchpad"
  ];
in
{
  xdg.configFile = lib.mkMerge [
    {
      "hypr/hyprland.lua".source = ../../home/.config/hypr/hyprland.lua;
      "hypr/plugins.lua".source = ../../home/.config/hypr/plugins.lua;
      "hypr/dms/binds-user.lua".source = ../../home/.config/hypr/dms/binds-user.lua;
      "hypr/dms/windowrules.lua".source = ../../home/.config/hypr/dms/windowrules.lua;

      "wallpapers" = {
        source = ../../home/.config/wallpapers;
        recursive = true;
      };
    }
    (lib.listToAttrs (
      map (s: {
        name = "hypr/scripts/${s}.sh";
        value = {
          source = ../../home/.config/hypr/scripts + "/${s}.sh";
          executable = true;
        };
      }) scripts
    ))
  ];
}
