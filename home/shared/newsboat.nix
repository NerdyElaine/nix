{
  config,
  pkgs,
  ...
}: {
  programs.newsboat = {
    enable = true;
    autoReload = true;
    extraConfig = ''
      bind-key i open
      bind-key n down
      bind-key e up
      bind-key m quit
      bind-key N next-feed articlelist
      bind-key E prev-feed articlelist
      bind-key a toggle-article-read
      bind-key G end
      bind-key g home
      bind-key s pagedown
      bind-key l pageup

      color info           color236 green bold
      color listfocus         color10 color237
      color listfocus_unread  color9  color237
      color listnormal        color7  default
      color listnormal_unread color15 default
    '';
  };
}
