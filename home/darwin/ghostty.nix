{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."ghostty" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/home/custom/ghostty";
    recursive = false;
  };
}
