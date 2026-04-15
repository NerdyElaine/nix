{ config, pkgs, ... }:
{
  xdg.configFile."yazi" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/home/custom/yazi";
    recursive = false;
  };
}
