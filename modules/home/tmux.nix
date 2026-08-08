# Replaces home/.tmux.conf + TPM. `programs.tmux.plugins` writes store paths
# straight into the generated config, so nothing lives under ~/.tmux any more
# and the tpm submodule is gone.
{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 5000000;
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";
    shell = "${pkgs.zsh}/bin/zsh";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      jump
      cowboy # from pkgs/tmux-cowboy.nix
      vim-tmux-navigator
      {
        plugin = tmux-window-name;
        extraConfig = ''
          set -g @tmux_window_name_shells "['bash', 'fish', 'sh', 'zsh']"
          set -g @tmux_window_name_dir_programs "['nvim', 'vim', 'vi', 'git', 'lazygit']"
          set -g @tmux_window_name_show_program_args "False"
          set -g @tmux_window_name_use_tilde "False"
          set -g @tmux_window_name_max_name_len "40"
        '';
      }
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '1'
        '';
      }
      {
        plugin = dracula;
        extraConfig = ''
          set-option -g status-justify centre
          set -g @dracula-plugins "cpu-usage ram-usage sys-temp"
          if-shell 'command -v nvidia-smi >/dev/null && nvidia-smi -L >/dev/null' \
            'set -g @dracula-plugins "cpu-usage ram-usage gpu-usage gpu-ram-usage gpu-power-draw sys-temp"'
          set -g @dracula-show-flags true
          set -g @dracula-refresh-rate 3
          set -g @dracula-show-left-icon session
          set -g @dracula-border-contrast false
          set -g @dracula-show-empty-plugins false
          set -g @dracula-force-gpu "NVIDIA"
          set -g @dracula-show-ssh-only-when-connected true
        '';
      }
    ];

    extraConfig = ''
      set-option -w -g aggressive-resize on
      bind-key b set-option status

      setw -g pane-base-index 1
      set-option -g renumber-windows on

      # open new windows/panes in the same dir
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # easy session
      bind C command-prompt -p "New Session:" "new-session -A -s '%%'"
      bind-key S 'display-popup -w 80% -E "tmux list-sessions | fzf"'

      # vim coloring
      set-option -ga terminal-overrides ",xterm-256color:Tc"
      set -ag terminal-overrides ",xterm-256color:RGB"
      # like vim split
      bind h split-window -v
      bind v split-window -h

      # copy mode
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel
      bind P paste-buffer
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel
      # Set focus-events on (important for Neovim autoread)
      set -g focus-events on

      set -g prefix M-`
      set -g prefix2 C-b

      set -g display-time 4000
      set -g status-interval 5

      # mouse copy
      set-option -s set-clipboard off
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "wl-copy"

      # save session on detach. The old config hardcoded
      # ~/.tmux/plugins/tmux-resurrect/scripts/save.sh, which no longer exists.
      bind d run-shell "${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts/save.sh && tmux detach"
    '';
  };
}
