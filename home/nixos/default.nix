{ config, pkgs, inputs, username, ... }:
{
imports = [
    ../shared/fish.nix
    ../shared/nvim.nix
    ../shared/sioyek.nix
    ./firefox.nix
    ../shared/rmpc.nix
    ./firefox.nix
    ./foot.nix
    ./mangowc.nix
    ./waybar.nix
    ./wmenu.nix
    ../shared/tmux.nix
    ../shared/yazi.nix
    ../shared/mpv.nix
];
home.username = "elaine";
home.homeDirectory = "/home/elaine";
home.stateVersion = "26.05";
}
