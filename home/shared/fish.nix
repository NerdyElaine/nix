{pkgs, ...}: {
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_cursor_default     block
      set fish_cursor_insert      block
      set fish_cursor_replace_one block
      set fish_cursor_replace     block
      set fish_cursor_external    line
      set fish_cursor_visual      block
      set fish_greeting ""

      set -gx ATUIN_NOBIND "true"
      atuin init fish | source
      bind \ch _atuin_search
      bind -M insert \ch _atuin_search

      fish_add_path $HOME/.cargo/bin
      fish_add_path $HOME/.local/bin
      fish_add_path /run/current-system/sw/bin
      set -gx LIBRARY_PATH /opt/homebrew/opt/libiconv/lib $LIBRARY_PATH

      fzf --fish | source

      function starship_transient_prompt_func
        starship module character
      end
      starship init fish | source
      enable_transience

      hyfetch
    '';

    shellAliases = {
      v = "vim";
      vi = "nvim";
      inv = ''nvim $(fzf -m --preview="bat --color=always {}")'';
      o = "open";
      owd = "open ./";
      fm = ". yazi";
      fhistory = "history | rg";
      dis3d = "$HOME/.cargo/bin/display3d";
      ff = "hyfetch -b fastfetch";
      fzf = ''fzf --preview="bat -f {}"'';

      # Kanata
      kbd = "sudo kanata --cfg ~/nix/home/custom/kanata/colemak-dh-ansi.kbd";

      # Git
      gl = "git log --graph --abbrev-commit --decorate --date=relative --all";
      glo = "git log --oneline --graph --abbrev-commit --decorate --date=relative --all";
      gst = "git status --short --find-renames --branch";
      gstu = "git status --short --find-renames --branch --untracked-files";
      ga = "git add";
      gaa = "git add -A";
      gcm = "git commit -m";
      gcam = "git commit -am";
      gd = "git diff";

      # Eza
      ls = "eza --icons --group-directories-first";
      la = "eza -a --icons --group-directories-first";
      lsa = "eza -a --icons --group-directories-first";
      ll = "eza -lah --icons --group-directories-first";
      l = "eza -lh --icons --group-directories-first";
      tree = "eza -T --icons -D --group-directories-first";
      treeall = "eza --tree --icons --group-directories-first";

      # File shortcuts
      icloud = "yazi ~/Library/Mobile\\ Documents/com~apple~CloudDocs/";
    };

    functions = {
      fish_user_key_bindings = ''
        fish_default_key_bindings -M insert
        fish_vi_key_bindings

        bind --preset -M default m 'fish_vi_run_count backward-char'
        bind --preset -M default n 'fish_vi_run_count down-or-search'
        bind --preset -M default e 'fish_vi_run_count up-or-search'
        bind --preset -M default i 'fish_vi_run_count forward-char'
        bind --preset -m insert u repaint-mode
        bind --preset -m insert U beginning-of-line repaint-mode
        bind --preset -M default f 'fish_vi_run_count forward-word-end'
        bind --preset -M default F 'fish_vi_run_count forward-bigword-end'
        bind --preset -M operator m 'fish_vi_run_count backward-char'
        bind --preset -M operator n 'fish_vi_run_count forward-char'
        bind --preset -M operator e 'fish_vi_run_count up-or-search'
        bind --preset -M operator i 'fish_vi_run_count down-or-search'
        bind --preset -M operator f 'fish_vi_run_count forward-word-end'
        bind --preset -M operator F 'fish_vi_run_count forward-bigword-end'
        bind --erase \ci
        bind --erase \cm
      '';
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # Let zoxide hook into fish
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      search_mode = "fuzzy";
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
   
  home.packages = with pkgs; [
    eza
    bat
    ripgrep
    yazi
    hyfetch
    fastfetch
    sccache
    kanata
    fd
    fzf
  ];
}
