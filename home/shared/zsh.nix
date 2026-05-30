{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    fzf
    zoxide
    eza        # better ls
    bat        # better cat
    fd         # better find
    ripgrep
    starship
  ];

  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      share = true;
    };
    
    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "v1.1.2";
          sha256 = "sha256-Qv8zAiMtrr67CbLRrFjGaPzFZcOiMVEFLg1Z+N6VMhg=";
        };
      }
      {
        name = "zsh-colored-man-pages";
        src = pkgs.fetchFromGitHub {
          owner = "ael-code";
          repo = "zsh-colored-man-pages";
          rev = "master";
          sha256 = "sha256-087bNmB5gDUKoSriHIjXOVZiUG5+Dy9qv3D69E8GBhs=";
        };
      }
    ];

    completionInit = ''
      autoload -Uz compinit
      compinit

      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*:*:*:*:descriptions' format '%F{green}── %d ──%f'
      zstyle ':fzf-tab:*' fzf-command fzf
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --color=always $realpath 2>/dev/null'
    '';

    initContent = lib.mkBefore ''
      bindkey -v

      function _colemak_dh_binds {
        bindkey '^?' backward-delete-char
        bindkey -M vicmd 'm' vi-backward-char        
        bindkey -M vicmd 'n' down-line-or-history    
        bindkey -M vicmd 'e' up-line-or-history       
        bindkey -M vicmd 'i' vi-forward-char          

        bindkey -M vicmd 'f' vi-forward-word-end       
        bindkey -M vicmd 'F' vi-forward-blank-word-end 

        bindkey -M vicmd 'k' vi-repeat-search           
        bindkey -M vicmd 'K' vi-rev-repeat-search       

        bindkey -M vicmd 's' vi-insert             
        bindkey -M vicmd 'S' vi-insert-bol         

        bindkey -M vicmd 'a' vi-add-next
        bindkey -M vicmd 'A' vi-add-eol                

        bindkey -M vicmd 'u' undo
        # Standard Zsh doesn't have native 'redo' bound to a default widget out-of-the-box,
        # but 'undo' will toggle changes. 

        bindkey -M vicmd 'M' vi-beginning-of-line 
        bindkey -M vicmd 'I' vi-end-of-line       

        # Visual Mode (Zsh calls this 'visual')
        bindkey -M visual 'm' vi-backward-char
        bindkey -M visual 'n' down-line-or-history
        bindkey -M visual 'e' up-line-or-history
        bindkey -M visual 'i' vi-forward-char
        bindkey -M visual 'j' vi-forward-word-end
        bindkey -M visual 'J' vi-forward-blank-word-end
        bindkey -M visual 'k' vi-repeat-search
        bindkey -M visual 'K' vi-rev-repeat-search
        bindkey -M visual 'M' vi-beginning-of-line
        bindkey -M visual 'I' vi-end-of-line

        # Insert Mode (viins) Binds
        bindkey -M viins '^P' history-substring-search-up
        bindkey -M viins '^N' history-substring-search-down

        bindkey -M viins '^E' end-of-line
        bindkey -M viins '^A' beginning-of-line

        bindkey -M viins '^ ' autosuggest-accept
      }
      
      # Run the bind key definitions
      _colemak_dh_binds

     function set_block_cursor() {
        echo -ne '\e[2 q'
      }
      starship_precmd_user_func=set_block_cursor

      function zle-line-init-wrapped() {
        echo -ne '\e[2 q'
      }
      autoload -Uz add-zle-hook-widget
      add-zle-hook-widget zle-line-init zle-line-init-wrapped

      eval "$(zoxide init zsh)"
      eval "$(starship init zsh)"
      
      TRANSIENT_PROMPT="''${PROMPT// prompt / prompt --profile transient }"
      TRANSIENT_RPROMPT="''${PROMPT// prompt / prompt --profile rtransient }"

      autoload -Uz add-zsh-hook
      add-zsh-hook precmd transient-prompt-precmd

      function transient-prompt-precmd {
        TRAPINT() { transient-prompt; return $(( 128 + $1 )) }
        SAVED_PROMPT="$(eval "printf '%s' \"''${TRANSIENT_PROMPT}\"")"
        SAVED_RPROMPT="$(eval "printf '%s' \"''${TRANSIENT_RPROMPT}\"")"
      }

      autoload -Uz add-zle-hook-widget
      add-zle-hook-widget zle-line-finish transient-prompt

      function transient-prompt() {
        PROMPT="$SAVED_PROMPT" RPROMPT="$SAVED_RPROMPT" zle .reset-prompt
      }

      alias ls='eza --icons --group-directories-first'
      alias ll='eza -lah --icons --group-directories-first --git'
      alias lt='eza --tree --icons --level=2'
      alias cat='bat --paging=never'
      alias grep='grep --color=auto'
      alias ..='cd ..'
      alias ...='cd ../..'
      alias ....='cd ../../..'
      alias kbd = 'sudo kanata --cfg ~/nix/home/custom/kanata/colemak-dh-ansi.kbd'
      alias icloud = 'yazi ~/Library/Mobile\\ Documents/com~apple~CloudDocs/'
      alias gl = 'git log --graph --abbrev-commit --decorate --date=relative --all'
      alias glo = 'git log --oneline --graph --abbrev-commit --decorate --date=relative --all'
      alias gst = 'git status --short --find-renames --branch'
      alias gstu = 'git status --short --find-renames --branch --untracked-file'
      alias ga = 'git add'
      alias gaa = 'git add -A'
      alias gcm = 'git commit -m'
      alias gcam = 'git commit -am'
      alias gd = 'git diff'

      setopt AUTO_CD
      setopt CORRECT
      setopt INTERACTIVE_COMMENTS
      setopt NO_BEEP
      setopt GLOB_DOTS
      function zle-keymap-select zle-line-init zle-line-finish {
      echo -ne "\e[2 q"
}
      zle -N zle-keymap-select
      zle -N zle-line-init
      zle -N zle-line-finish
    '';

    sessionVariables = {
      KEYTIMEOUT = "1"; # 0.01 seconds (Zsh KEYTIMEOUT uses units of 1/100th of a second)
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      
      format = pkgs.lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$nix_shell"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];
      profiles = {
        transient = ''
          $character
        '';
        rtransient = ''
          $cmd_duration
        '';
      };
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol   = "[❯](bold red)";
        vimcmd_symbol  = "[❮](bold yellow)";
      };

      directory = {
        style             = "bold cyan";
        truncation_length = 4;
        truncate_to_repo = true;
        substitutions = {
          "~" = " ~";
        };
      };

      git_branch = {
        symbol = " ";
        style  = "bold purple";
        format = "[$symbol$branch]($style) ";
      };

      git_status = {
        style    = "bold yellow";
        format   = "([$all_status$ahead_behind]($style) )";
        ahead    = "⇡\${count}";
        behind   = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        modified = "!";
        staged   = "+";
        untracked = "?";
        deleted  = "✘";
      };

      cmd_duration = {
        min_time = 2000;
        format   = "[ $duration]($style) ";
        style    = "bold yellow";
      };

      nix_shell = {
        symbol = " ";
        style  = "bold blue";
        format = "[$symbol$state( \\($name\\))]($style) ";
      };
    };
  };
}
