# hosts/nixos/default.nix
{ config, pkgs, inputs, username, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix
  ];

  #  Bootloader 
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  # Kernel 
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.config.allowUnfree = true;

  # NVIDIA
  hardware.nvidia = {
    modesetting.enable    = true;
    powerManagement.enable = false;
    open                  = false;   # proprietary closed-source kernel module
    nvidiaSettings        = true;
    package               = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics = {
    enable      = true;
    enable32Bit = true;             # needed for Steam / 32-bit GL
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  services.displayManager.ly.enable = true;

  # Required env vars for Wayland + NVIDIA + mango
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME    = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS   = "1";   # fixes cursor on NVIDIA under wlroots
    GBM_BACKEND          = "nvidia-drm";
    MOZ_ENABLE_WAYLAND   = "1";
    NIXOS_OZONE_WL       = "1";        # Electron / Chromium Wayland
  };

  # Mangowc 
  programs.mango.enable = true;

  # Networking 
  networking.hostName = "transnix";
  networking.networkmanager.enable = true;

  # Locale & time 
  time.timeZone = "Asia/Phnom_Penh";

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT    = "en_GB.UTF-8";
    LC_MONETARY       = "en_GB.UTF-8";
    LC_NAME           = "en_GB.UTF-8";
    LC_NUMERIC        = "en_GB.UTF-8";
    LC_PAPER          = "en_GB.UTF-8";
    LC_TELEPHONE      = "en_GB.UTF-8";
    LC_TIME           = "en_GB.UTF-8";
  };

  # Console 
  console = {
    earlySetup = true;
  };

  # Pipewire audio 
  services.pulseaudio.enable = false;   # must be off when using Pipewire
  security.rtkit.enable      = true;    # realtime scheduling for Pipewire

  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
    jack.enable       = true;
  };

  # Bluetooth 
  hardware.bluetooth = {
    enable      = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # XDG desktop portal 
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };

  programs.fish.enable = true;

  security.sudo.enable = false;
  security.sudo.configFile = ''
   %wheel ALL=(ALL) ALL
  '';

  # User 
  users.users.elaine = {
    isNormalUser = true;
    description  = "elaine";
    extraGroups  = [ "wheel" "networkmanager" "audio" "video" "input" ];
    shell        = pkgs.fish;
  };

  # System packages 
  environment.systemPackages = with pkgs; [
    # Wayland essentials
    wayland
    wayland-utils
    wl-clipboard
    xwayland

    # Display / GPU utils
    libva-utils
    nvidia-vaapi-driver
    mesa-demos
    vulkan-tools

    # Screenshot
    grim
    slurp

    # Wallpaper
    swaybg

    # Networking
    networkmanagerapplet

    # General tools
    wget
    curl
    git
    lazygit
    htop
    unzip
  ];

  # Fonts 
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.noto
    noto-fonts
    nerd-fonts.iosevka
    noto-fonts-color-emoji
  ];

  # Security 
  security.polkit.enable = true;

  # Nix settings 
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store   = true;
  };

  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 14d";
  };

  system.stateVersion = "24.11";
}
