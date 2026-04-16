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

  time.timeZone = "Asia/Phnom_Penh";

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
  mpv
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
          swapLeftCommandAndLeftAlt = true; 
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
      "sk"
      "cava"
      "bob"
      "fd"
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
      "keycastr"
      "vesktop"
      "protonvpn"
      "anki"
      "docker-desktop"
      "element"
      "beeper"
      "telegram"
      "karabiner-elements"
      "raycast"
    ];

    masApps = {
    };
  };

  system.stateVersion = 5;
}
