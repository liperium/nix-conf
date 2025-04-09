{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    catppuccin.url = "github:catppuccin/nix";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nixos-hardware
    , catppuccin
    , hyprpanel
    , chaotic
    , ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      hyprland-stuff = [
        {
          nix.settings = {
            substituters = [ "https://hyprland.cachix.org" ];
            trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
          };
        }
        {
          nixpkgs.overlays = [ hyprpanel.overlay ];
        }
      ];
      # Imports the RELEVANT home manager module to the system
      home-manager-liperium-root = { hyprMonitor, userImports ? [ "./home/desktop.nix" ] }: [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.liperium = {
              imports = userImports ++ [
                catppuccin.homeManagerModules.catppuccin
              ];
            };
            users.root = import ./home/root.nix;
            backupFileExtension = "hm_backup";
            extraSpecialArgs = {
              inherit system;
              inherit inputs;
              inherit hyprMonitor;
            };
          };
        }
      ];
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
            hyprMonitor = {
              primary = "DP-1";
              secondary = "eDP-1";
              settings = [
                "DP-1,1920x1080@119.98,0x0,1.0"
                "eDP-1,preferred,1920x0,1.175"
                ",preferred,auto,1"
              ];
            };
            userImports = [
              ./home/hyprland.nix
            ];
          }
          ++ hyprland-stuff;
        };

        battleship = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/battleship
            chaotic.nixosModules.default
          ]
          ++ home-manager-liperium-root {
            hyprMonitor = {
              primary = "DP-1";
              secondary = "DP-2";
              settings = [
                "DP-1,2560x1440@164.80,auto,1.25"
                "DP-2,preferred,auto,1.25"
                ",preferred,auto,1"
              ];
            };
            userImports = [
              ./home/hyprland.nix
            ];
          }
          ++ hyprland-stuff;
        };

        atlas = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/atlas ];
        };

        shuttle = lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-4
            "${nixpkgs}/nixos/modules/profiles/minimal.nix"
            ./hosts/shuttle
          ];
        };
      };
    };
}
