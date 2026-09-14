{ config, lib, ... }:
let
  dotfiles = "${config.ak.dotfilesDir}/home";
  link = rel: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${rel}";
in
{
  home.file = {
    ".zshrc".source = link ".zshrc";
    ".tmux.conf".source = link ".tmux.conf";
    ".tmux/plugins/tpm".source = link ".tmux/plugins/tpm";
  };

  xdg.configFile = {
    "zsh".source = link ".config/zsh";
    "alacritty".source = link ".config/alacritty";
    "lazygit/config.yml".source = link ".config/lazygit/config.yml";
  };

  home.activation.touchUntrackedZsh = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -d "${dotfiles}/.config/zsh" ] && [ ! -e "${dotfiles}/.config/zsh/untracked.zsh" ]; then
      run touch "${dotfiles}/.config/zsh/untracked.zsh"
    fi
  '';
}
