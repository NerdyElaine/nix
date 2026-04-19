{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    keyMode = "vi";
    terminal = "tmux-256color";
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
    ];
    extraConfig = ''
                # term
                  set -ga terminal-overrides ",*:RGB"

      # prefix is `
                  set -g prefix `
                  bind C-q send-prefix
                  unbind C-b

      #stuff
                  set -gq allow-passthrough on

                  set -ga update-environment TERM
                  set -ga update-environment TERM_PROGRAM


      # so vim and co is not hell
                  set -sg escape-time 1
                  set -g base-index 1
                  setw -g pane-base-index 1

      # mouse works as expected
                  set -g mouse on

                  setw -g monitor-activity on
                  set -g visual-activity on

                  set -g mode-keys vi
                  set -g history-limit 10000
                  set -g set-clipboard on

                  bind c new-window -c "#{pane_current_path}"
                  bind R source-file ~/.tmux.conf

      # easy-to-remember split pane commands
                  bind v split-window -h -c "#{pane_current_path}"
                  bind h split-window -v -c "#{pane_current_path}"
                  unbind '"'
                  unbind %

      # resize panes with vim movement keys
                  bind -r m resize-pane -L 5
                  bind -r n resize-pane -D 5
                  bind -r e resize-pane -U 5
                  bind -r i resize-pane -R 5

      #Sessionizer scripts
                  bind B run "~/nix/home/custom/scripts/tmux-session-dispensary.sh ~/Library/Mobile\ Documents/com~apple~CloudDocs"
                  bind P run "~/nix/home/custom/scripts/tmux-session-dispensary.sh ~/documents/projects"
                  bind N run "~/nix/home/custom/scripts/tmux-session-dispensary.sh ~/nix"
                  bind H run "~/nix/home/custom/scripts/tmux-session-dispensary.sh ~"
                  bind O run "~/nix/home/custom/scripts/tmux-session-dispensary.sh ~/orgfiles"
                  bind W run "~/nix/home/custom/scripts/tmux-session-dispensary.sh ~/dev/personalwebsite"
                  bind f display-popup \
                      -T "#[align=centre]Sessionizer" -x C -y C \
                      -d "#{pane_current_path}" \
                      -w 75% \
                      -h 75% \
                      -E "~/nix/home/custom/scripts/tmux-session-dispensary.sh"

      #Lazygit integration
                  bind g display-popup \
                      -d "#{pane_current_path}" \
                      -w 80% \
                      -h 80% \
                      -E "lazygit"

      #tmux nvim

      # Unbind default vim-tmux-navigator keys (if needed)
            unbind -n C-h
            unbind -n C-j
            unbind -n C-k
            unbind -n C-l

            # Bind new navigation keys: m n e i
            # Left
            bind -n C-m run-shell "tmux select-pane -L"
            # Down
            bind -n C-n run-shell "tmux select-pane -D"
            # Up
            bind -n C-e run-shell "tmux select-pane -U"
            # Right
            bind -n C-i run-shell "tmux select-pane -R"

            # Make vim-tmux-navigator aware of new keys
            set -g @vim_navigator_mapping_left "C-m"
            set -g @vim_navigator_mapping_down "C-n"
            set -g @vim_navigator_mapping_up "C-e"
            set -g @vim_navigator_mapping_right "C-i"

      #Everforest Palette
                  text_color="#D3C6AA"
                  green="#A7C080"
                  red="#E67E80"
                  cyan="#7FBBB3"
                  dark_text="#272E33"
                  everforest_bg1="#2e383c"

      #bar
                  set -g status-style "fg=#D3C6AA bg=default"
                  set -g status-position top
                  set -g status-left-length 100
                  set -g status-left "#[fg=#A7C080,bold]#S #[fg=#D3C6AA, nobold]|"
                  set -g status-justify absolute-centre
                  set -g visual-activity off
                  set -g window-status-activity-style none
                  set -g window-status-current-format "#[fg=#E67E80, bold] #I:#W"
                  set -g status-right "#[fg=#D3C6AA]| #[fg=#A7C080, bold]%H:%M %d-%b-%y"
                  set -g message-style "fg=#D3C6AA, bg=default"
                  set -g mode-style "fg=#272E33, bg=#A7C080"

      #border
                  set -g pane-border-style "fg=#2e383c" # fg=bg1
                  set -g pane-active-border-style "fg=#A7C080" # fg=blue

    '';
  };
}
