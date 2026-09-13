# Links the stow-style dotfiles under home/ into ~. The files stay plain
# dotfiles because other, non-NixOS machines consume the same tree; nothing in
# here is generated from Nix.
#
# Out-of-store symlinks into the live checkout (same mechanism as nvim.nix):
# edits take effect without a rebuild, and tools that write next to their
# config (tpm, zinit, *.zwc caches, untracked.zsh) can do so. ak.dotfilesDir
# (default ~/Projects/dotfiles) is therefore load-bearing.
{ config, lib, ... }:
let
  dotfiles = "${config.ak.dotfilesDir}/home";
  link = rel: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${rel}";
in
{
  home.file = {
    ".zshrc".source = link ".zshrc";
    ".tmux.conf".source = link ".tmux.conf";
    # ~/.tmux/plugins itself stays a real directory so tpm can clone the other
    # plugins next to it (.tmux.conf does that on the first tmux start).
    ".tmux/plugins/tpm".source = link ".tmux/plugins/tpm";
  };

  xdg.configFile = {
    # Whole directory: untracked.zsh (gitignored) and the *.zwc caches live in
    # the checkout, exactly as with stow.
    "zsh".source = link ".config/zsh";
    # Includes the themes/ submodule that alacritty.toml imports. The alacritty
    # binary itself comes from ../setup (desktop machines only).
    "alacritty".source = link ".config/alacritty";
    "lazygit/config.yml".source = link ".config/lazygit/config.yml";
  };

  # .zshrc sources zsh/untracked.zsh unconditionally; the file is gitignored
  # (per-machine secrets/overrides). Touch it so a fresh shell does not complain.
  home.activation.touchUntrackedZsh = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -d "${dotfiles}/.config/zsh" ] && [ ! -e "${dotfiles}/.config/zsh/untracked.zsh" ]; then
      run touch "${dotfiles}/.config/zsh/untracked.zsh"
    fi
  '';
}
