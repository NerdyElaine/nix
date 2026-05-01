{
  config,
  pkgs,
  inputs,
  username,
  ...
}: {
  imports = [
    ./package/aerospace.nix
  ];

  networking.hostName = "transbook";

  # Nix daemon settings
  nix.enable = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

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
    imagemagick
    btop
    pandoc
    ghostscript
    rmpc
    mpd
    gcc
    zotero
    coreutils-prefixed
    glibtool
    keepassxc
    cinny-desktop
    yams
    texliveFull
    gh
    iosevka
    python3
    cmake
    meson
    gnupg
    lazygit
    vesktop
    enchant
    aspell
    pkg-config
    nixd
    tmux
    ffmpegthumbnailer
    poppler-utils
    mediainfo
    gnutar
    bat
    mpv
    yt-dlp
    kanata
    neovim
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
  ];

  # macOS system defaults
  system.defaults = {
    dock.autohide = true;
    dock.autohide-delay = 0.0;
    dock.autohide-time-modifier = 0.0;
    menuExtraClock.Show24Hour = true;
    dock.mru-spaces = false;
    finder.AppleShowAllExtensions = true;
    finder.CreateDesktop = false;
    finder.FXPreferredViewStyle = "clmv";
    universalaccess.reduceMotion = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.InitialKeyRepeat = 15;
    NSGlobalDomain.KeyRepeat = 2;
    NSGlobalDomain._HIHideMenuBar = true;
    NSGlobalDomain.ApplePressAndHoldEnabled = false;
  };
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
  
  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 3; Minute = 15;};
    options = "--delete-older-than 7d";
  };
  
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    brews = [
      "mas"
      "ninja"
      "meson"
      "mpc"
      "libiconv"
      "rust"
      "rustup"
      "sk"
      "cava"
      "bob"
      "libvterm"
      "fd"
      "felixkratz/formulae/borders"
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
      "tunnelblick"
      "protonvpn"
      "helium-browser"
      "anki"
      "docker-desktop"
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
