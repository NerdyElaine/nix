{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."mpv" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/home/custom/mpv";
    recursive = false;
  };
}
