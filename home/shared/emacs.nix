{
  config,
  pkgs,
  ...
}: {
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.vterm
      epkgs.pdf-tools
    ];
  };
  home.file.".emacs.d".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/home/custom/emacs";
}
