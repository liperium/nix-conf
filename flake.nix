{
  inputs = {
    # Nix basics
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-server.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-caddy.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Desktop/Customizations
    catppuccin.url = "github:catppuccin/nix";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Server stuff
    vpn-confinement.url = "github:Maroka-chan/VPN-Confinement";
    mtg-card-scraper = {
      url = "git+ssh://git@github.com/liperium/mtg-card-scraper";
      inputs.nixpkgs.follows = "nixpkgs-server";
    };
    ml-production-website = {
      url = "git+ssh://git@github.com/liperium/ml-production-website";
      inputs.nixpkgs.follows = "nixpkgs-server";
    };
    construct3-hoster = {
      url = "git+ssh://git@github.com/liperium/construct3-hoster";
      inputs.nixpkgs.follows = "nixpkgs-server";
    };
    mtg-deck-tool = {
      url = "git+ssh://git@github.com/liperium/mtg-deck-tool";
      inputs.nixpkgs.follows = "nixpkgs-server";
    };
  };
  nixConfig = {
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://nix-community.cachix.org"
      "https://claude-code.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
    ];
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nixos-hardware
    , catppuccin
      #, chaotic
    , sops-nix
    , vpn-confinement
    , ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      # Imports the RELEVANT home manager module to the system
      home-manager-liperium-root = { hyprMonitor, userImports ? [ ./home/console.nix ] }: [
        home-manager.nixosModules.home-manager
        ({ pkgs, ... }: {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.liperium = {
              imports = userImports ++ [
                catppuccin.homeModules.catppuccin
                inputs.noctalia.homeModules.default
              ];
            };
            users.root = import ./home/root.nix;
            backupCommand = ''
              ${pkgs.coreutils}/bin/mv -f "$1" "$1.hm_backup"
            '';
            extraSpecialArgs = {
              inherit system;
              inherit inputs;
              inherit hyprMonitor;
            };
          };
        })
      ];
      # Global modules to add to ALL confs
      globalModules = [ sops-nix.nixosModules.sops ];
    in
    {
      images. shuttle = self.nixosConfigurations.shuttle.config.system.build.image;

      packages.x86_64-linux.shuttle-image = self.nixosConfigurations.shuttle.config.system.build.image;
      packages.aarch64-linux.shuttle-image = self.nixosConfigurations.shuttle.config.system.build.image;

      nixosConfigurations = {
        frigate = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/frigate
            nixos-hardware.nixosModules.framework-intel-core-ultra-series1
          ]
          ++ home-manager-liperium-root {
            hyprMonitor = { };
            userImports = [
              ./home/niri.nix
            ];
          }
          ++ globalModules;
        };

        battleship = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/battleship
          ]
          ++ home-manager-liperium-root {
            hyprMonitor = {
              primary = "DP-1";
              secondary = "DP-2";
              settings = [ ];
            };
            userImports = [
              ./home/niri.nix
            ];
          }
          ++ globalModules;
        };

        atlas = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/atlas ]
            ++ globalModules;
        };

        shuttle = lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-4
            "${nixpkgs}/nixos/modules/profiles/minimal.nix"
            ./hosts/shuttle
          ] ++ globalModules;
        };
        shuttle-n150 = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/shuttle-n150
            vpn-confinement.nixosModules.default
          ]
          ++ home-manager-liperium-root { hyprMonitor = { }; }
          ++ globalModules;
        };
      };
    };
}
