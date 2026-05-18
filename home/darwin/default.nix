{
  config,
  pkgs,
  inputs,
  username,
  ...
}: {
  imports = [
    ./aerospace.nix
    ../shared/fish.nix
    ../shared/git.nix
   # ../shared/nvim-bak.nix
    ./firefox.nix
    ../shared/emacs.nix
    ./mpd.nix
    ../shared/tmux.nix
    ./neru.nix
    ./ghostty.nix
    ./sketchybar.nix
    ../shared/mpv.nix
  ];
  home.username = "elaine";
  home.homeDirectory = "/Users/elaine";
  home.stateVersion = "26.05";
}
