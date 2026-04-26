{
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Symlink your existing nvim config directory into ~/.config/nvim
  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/home/custom/nvim";
    recursive = false;
  };
}
