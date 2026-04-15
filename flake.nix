{
  description = "NixOS + Darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs";};
    niri = { url = "github:sodiboo/niri-flake"; inputs.nixpkgs.follows = "nixpkgs";};
    nix-homebrew = { url = "github:zhaofengli/nix-homebrew"; inputs.nixpkgs.follows = "nixpkgs";};
    homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
    homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };
    homebrew-bundle = { url = "github:homebrew/homebrew-bundle"; flake = false; };
    homebrew-formulae = { url = "github:FelixKratz/homebrew-formulae"; flake = false;};
    textfox.url = "github:adriankarlen/textfox";
    arkenfox = { url = "github:dwarfmaster/arkenfox-nixos"; inputs.nixpkgs.follows = "nixpkgs"; };
    firefox-addons = { url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons"; inputs.nixpkgs.follows = "nixpkgs";};
    neru = { url = "github:y3owk1n/neru"; inputs.nixpkgs.follows = "nixpkgs";};
  };

  outputs = { self, nix-darwin, nixpkgs, home-manager, niri, neru, nix-homebrew, homebrew-cask, homebrew-core, homebrew-bundle, homebrew-formulae, ...}@inputs:
    let
    lib = nixpkgs.lib;
    username = "elaine";
  in 
  {
    nixosConfigurations.nixbox = lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs username; };
      modules = [
        niri.nixosModules.niri
        ./hosts/nixos/default.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs username; };
          home-manager.users.${username} = import ./home/nixos;
        }
      ];
    };
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit inputs username; };
      modules = [
        { nixpkgs.overlays = [ inputs.neru.overlays.default ]; }
        ./hosts/darwin/default.nix
        nix-homebrew.darwinModules.nix-homebrew {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;   # for x86 casks on Apple Silicon
            user = "elaine";
            autoMigrate = false;     # adopt existing brew install if present

            taps = {
              "homebrew/homebrew-core"   = homebrew-core;
              "homebrew/homebrew-cask"   = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
              "FelixKratz/homebrew-formulae" = homebrew-formulae;
            };

            mutableTaps = true;    # only taps declared above are allowed
          };
        }
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs username; };
          home-manager.users.${username} = {
                  imports = [
          ./home/darwin
          inputs.neru.homeManagerModules.default
          ];
        };
        }
      ];
    };
  };
}
