{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
      home-manager-liperium-root = { userImports ? [ "./home/desktop.nix" ] }: [
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
            };
          };
        }
      ];
    in
    {
      images.shuttle = self.nixosConfigurations.shuttle.config.system.build.image;

      packages.x86_64-linux.shuttle-image = self.nixosConfigurations.shuttle.config.system.build.image;
      packages.aarch64-linux.shuttle-image = self.nixosConfigurations.shuttle.config.system.build.image;


      nixosConfigurations = {
        frigate = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/frigate
            nixos-hardware.nixosModules.lenovo-legion-15arh05h
          ]
          ++ home-manager-liperium-root {
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
