# home/nixos/foot.nix
{ config, pkgs, ... }:

{
  programs.foot = {
    enable = true;

    settings = {
      main = {
        term                      = "xterm-256color";
        font                      = "monospace:size=11";
        dpi-aware                 = "auto";
        pad                       = "8x8 center";
        initial-window-size-chars = "100x30";
      };

      mouse.hide-when-typing = "yes";
      scrollback.lines       = 10000;

      colors = {
        background = "1e1e2e";
        foreground = "cdd6f4";
        regular0   = "45475a";
        regular1   = "f38ba8";
        regular2   = "a6e3a1";
        regular3   = "f9e2af";
        regular4   = "89b4fa";
        regular5   = "f5c2e7";
        regular6   = "94e2d5";
        regular7   = "bac2de";
        bright0    = "585b70";
        bright1    = "f38ba8";
        bright2    = "a6e3a1";
        bright3    = "f9e2af";
        bright4    = "89b4fa";
        bright5    = "f5c2e7";
        bright6    = "94e2d5";
        bright7    = "a6adc8";
      };

      key-bindings = {
        spawn-terminal       = "Control+Shift+n";
        search-start         = "Control+Shift+f";
        font-increase        = "Control+equal";
        font-decrease        = "Control+minus";
        font-reset           = "Control+0";
        clipboard-copy       = "Control+Shift+c XF86Copy";
        clipboard-paste      = "Control+Shift+v XF86Paste";
        primary-paste        = "Shift+Insert";
        scrollback-up-page   = "Shift+Page_Up";
        scrollback-down-page = "Shift+Page_Down";
      };

      url = {
        launch       = "xdg-open \${url}";
        osc8-privacy = "always";
      };
    };
  };
}
