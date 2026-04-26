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
    ../shared/newsboat.nix
    ../shared/git.nix
    ../shared/nvim-old.nix
    ../shared/sioyek.nix
    ./firefox.nix
    ../shared/emacs.nix
    ./ghostty.nix
    ../shared/rmpc.nix
    ./mpd.nix
    ../shared/tmux.nix
    ./neru.nix
    ../shared/yazi.nix
    ./sketchybar.nix
    ../shared/mpv.nix
  ];
  home.username = "elaine";
  home.homeDirectory = "/Users/elaine";
  home.stateVersion = "26.05";
}
