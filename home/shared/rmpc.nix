{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."rmpc" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/home/custom/rmpc";
    recursive = false;
  };
}
