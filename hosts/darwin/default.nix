{ config, pkgs, inputs, username, ... }:
{
  imports = [ 
  ./package/aerospace.nix
  ];

  networking.hostName = "transbook";

  # Nix daemon settings
  nix.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # required for fish to work as login shell
  programs.fish.enable = true;

  # required for user-scoped options like dock, defaults, launchd agents
  system.primaryUser = username;

  users.users.elaine = {
    home = "/Users/elaine";
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [ 
  git 
  curl 
  fish
  wget 
  btop
  rmpc
  gcc
  lazygit
  tmux
  fd
  yt-dlp
  ghostty-bin
  kanata
  neovim
  yazi
  ];

  fonts.packages = with pkgs; [
  nerd-fonts.iosevka
  nerd-fonts.jetbrains-mono
];

  # macOS system defaults
  system.defaults = {
    dock.autohide = true;
    dock.mru-spaces = false;
    finder.AppleShowAllExtensions = true;
    universalaccess.reduceMotion = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain._HIHideMenuBar = true;
    NSGlobalDomain.ApplePressAndHoldEnabled = false;
  };
  system.keyboard = {
          enableKeyMapping = true; 
          remapCapsLockToControl = true;
      };
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade    = true;
      cleanup    = "zap";
    };

    brews = [
      "mas"
      "ninja"
      "meson"
      "mpd"
      "mpc"
      "bob"
      "felixkratz/formulae/borders"
      "rust"
      "felixkratz/formulae/sketchybar"
      "pipx"
    ];

    casks = [
      "lulu"
      "shottr"
      "hot"
      "simpletex"
      "sf-symbols"
      "vesktop"
      "protonvpn"
      "anki"
      "docker-desktop"
      "karabiner-elements"
      "raycast"
    ];

    masApps = {
    };
  };

  system.stateVersion = 5;
}
