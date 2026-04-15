{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "Iosevka Nerd Font Mono";
      font-size = 13;
      theme = "Everforest Dark Hard";
      window-padding-x = 10;
      window-padding-y = 10;
      macos-titlebar-style = "hidden";
      cursor-style = "block";
      adjust-cell-width = 2;
      adjust-cell-height = 0;
      shell-integration = "fish";
      background-opacity = 0.95;
    };
  };
}
