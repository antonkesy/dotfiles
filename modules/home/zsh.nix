# Replaces tasks/terminal/zsh.yml and the imperative half of home/.zshrc:
# znap.zsh and zinit.zsh git-cloned their plugin managers on every shell start,
# and sdkman.zsh sourced a toolchain manager that ansible never installed.
{
  pkgs,
  lib,
  config,
  ...
}:
let
  # Fragments still sourced, in the original .zshrc order. Dropped:
  #   znap.zsh / zinit.zsh -> plugins are declarative below
  #   sdkman.zsh           -> jdk8/jdk21/maven/gradle are system packages now
  #   atuin.zsh            -> programs.atuin does the init
  fragments = [
    "untracked"
    "alias"
    "path"
    "dart"
    "go"
    "haskell"
    "scripts"
    "p10k"
    "opam"
    "rust"
  ];
in
{
  # recursive = true gives per-file symlinks, so ~/.config/zsh stays a real
  # writable directory — untracked.zsh and the *.zwc compiled caches still work.
  xdg.configFile."zsh" = {
    source = ../../home/.config/zsh;
    recursive = true;
  };

  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory; # keep ~/.zshrc, as before
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = false; # fast-syntax-highlighting is used instead

    history = {
      path = "${config.home.homeDirectory}/.histfile";
      size = 50000000;
      save = 50000000;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "command-not-found"
      ];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
        file = "share/zsh-completions/zsh-completions.plugin.zsh";
      }
      {
        name = "zsh-vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];

    # The p10k instant prompt has to stay above anything that may print.
    initContent = lib.mkMerge [
      (lib.mkOrder 500 ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
        export ZSH_DISABLE_COMPFIX=true
        export ZVM_VI_EDITOR=nvim
      '')
      # Guarded: untracked.zsh is gitignored, so it is absent from the flake
      # store and only appears once the user creates it.
      (lib.mkOrder 1000 (
        lib.concatMapStringsSep "\n" (
          f: ''[[ -r "$HOME/.config/zsh/${f}.zsh" ]] && source "$HOME/.config/zsh/${f}.zsh"''
        ) fragments
      ))
      # Aliases have to be last to avoid conflicts with oh-my-zsh defaults.
      (lib.mkOrder 1500 ''source "$HOME/.config/zsh/alias.zsh"'')
    ];
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    # Atuin owns Ctrl-R, as it did in the old home/.config/zsh/atuin.zsh.
    historyWidget.zsh.command = "";
  };
}
