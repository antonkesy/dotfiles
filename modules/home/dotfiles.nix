# Links the stow-style dotfiles under home/ into ~. The files stay plain
# dotfiles because other, non-NixOS machines consume the same tree; nothing in
# here is generated from Nix.
#
# Out-of-store symlinks into the live checkout (same mechanism as nvim.nix):
# edits take effect without a rebuild, and tools that write next to their
# config (tpm, zinit, *.zwc caches, untracked.zsh) can do so. ak.dotfilesDir
# (default ~/Projects/dotfiles) is therefore load-bearing.
#
# ~/.config/hypr is linked file by file on purpose: the directory has to stay a
# real, writable one so DankMaterialShell can generate colors/outputs/layout/
# cursor/binds.lua next to the hand-written files (see seed.nix).
{ config, lib, ... }:
let
  dotfiles = "${config.ak.dotfilesDir}/home";
  link = rel: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${rel}";

  hyprFiles = [
    "hypr/hyprland.lua"
    "hypr/plugins.lua"
    "hypr/dms/binds-user.lua"
    "hypr/dms/windowrules.lua"
  ]
  ++ map (s: "hypr/scripts/${s}.sh") [
    "calendar"
    "discord-scratchpad"
    "kill-menu"
    "mail-scratchpad"
    "music"
    "task-manager-scratchpad"
  ];
in
{
  home.file = {
    ".zshrc".source = link ".zshrc";
    ".tmux.conf".source = link ".tmux.conf";
    # ~/.tmux/plugins itself stays a real directory so tpm can clone the other
    # plugins next to it (prefix + I).
    ".tmux/plugins/tpm".source = link ".tmux/plugins/tpm";
  };

  xdg.configFile = {
    # Whole directory: untracked.zsh (gitignored) and the *.zwc caches live in
    # the checkout, exactly as with stow.
    "zsh".source = link ".config/zsh";
    # Includes the themes/ submodule that alacritty.toml imports.
    "alacritty".source = link ".config/alacritty";
    "lazygit/config.yml".source = link ".config/lazygit/config.yml";
    "wallpapers".source = link ".config/wallpapers";
  }
  // lib.genAttrs hyprFiles (f: {
    source = link ".config/${f}";
  });

  # .zshrc sources zsh/untracked.zsh unconditionally; the file is gitignored
  # (per-machine secrets/overrides). tasks/misc/dotfiles.yml used to touch it
  # before stowing; do the same so a fresh shell does not complain.
  home.activation.touchUntrackedZsh = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -d "${dotfiles}/.config/zsh" ] && [ ! -e "${dotfiles}/.config/zsh/untracked.zsh" ]; then
      run touch "${dotfiles}/.config/zsh/untracked.zsh"
    fi
  '';
}
