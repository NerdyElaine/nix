{
  config,
  pkgs,
  ...
}: {
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [ epkgs.vterm ];
  };
  home.file.".emacs.d".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/home/custom/emacs";
}
