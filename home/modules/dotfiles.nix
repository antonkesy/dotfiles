# home/ -> ~, out-of-store so edits apply without a rebuild and tools can write
# next to their config (tpm, zinit, *.zwc, untracked.zsh).
{ config, lib, ... }:
let
  dotfiles = "${config.ak.dotfilesDir}/home";
  link = rel: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${rel}";
in
{
  home.file = {
    ".zshrc".source = link ".zshrc";
    ".tmux.conf".source = link ".tmux.conf";
    # ~/.tmux/plugins stays real so tpm can clone into it
    ".tmux/plugins/tpm".source = link ".tmux/plugins/tpm";
  };

  xdg.configFile = {
    "zsh".source = link ".config/zsh";
    # includes the themes/ submodule
    "alacritty".source = link ".config/alacritty";
    "lazygit/config.yml".source = link ".config/lazygit/config.yml";
  };

  # .zshrc sources it unconditionally; gitignored
  home.activation.touchUntrackedZsh = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -d "${dotfiles}/.config/zsh" ] && [ ! -e "${dotfiles}/.config/zsh/untracked.zsh" ]; then
      run touch "${dotfiles}/.config/zsh/untracked.zsh"
    fi
  '';
}
