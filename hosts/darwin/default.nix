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


  # required for user-scoped options like dock, defaults, launchd agents
  system.primaryUser = username;

  users.users.elaine = {
    home = "/Users/elaine";
    ignoreShellProgramCheck = true;
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
    rmpc
    mpd
    fnm
    gcc
    zotero
    coreutils-prefixed
    glibtool
    keepassxc
    cinny-desktop
    yams
    texliveFull
    basedpyright
    gh
    meson
    elan
    hugo
    ffmpeg
    texlab
    vscode-langservers-extracted
    ghostty-bin
    gnupg
    lazygit
    vesktop
    enchant
    aspell
    nixd
    nixfmt
    tmux
    ffmpegthumbnailer
    mediainfo
    gnutar
    bat
    mpv
    yt-dlp
    kanata
    neovim
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka-term
    nerd-fonts.jetbrains-mono
    inputs.aporetic-nerd-font.packages.${pkgs.system}.default
    aporetic
    crimson-pro
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
      "autoconf"
      "automake"
      "pkg-config"
      "rust"
      "ghostscript"
      "rustup"
      "poppler"
      "libpng"
      "zlib"
      "cmake"
      "hunspell"
      "sk"
      "cava"
      "bob"
      "libvterm"
      "fd"
      "FelixKratz/formulae/sketchybar"
      "FelixKratz/formulae/borders"
      "pipx"
    ];

    casks = [
      "lulu"
      "shottr"
      "steam"
      "hot"
      "simpletex"
      "sf-symbols"
      "keycastr"
      "vesktop"
      "flux-app"
      "prismlauncher"
      "tunnelblick"
      "protonvpn"
      "linearmouse"
      "helium-browser"
      "anki"
      "syncthing-app"
      "colemak-dh"
      "c0re100-qbittorrent"
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
