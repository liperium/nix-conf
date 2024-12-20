{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    catppuccin.url = "github:catppuccin/nix";
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
    };
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nixos-hardware
    , catppuccin
    , nixos-cosmic
    , hyprpanel
    , chaotic
    , ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      cosmic-stuff =
        [
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          nixos-cosmic.nixosModules.default
        ];
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
      nixosConfigurations = {
        frigate = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/frigate
            nixos-hardware.nixosModules.lenovo-legion-15arh05h
          ]
          ++ home-manager-liperium-root {
            userImports = [
              ./home/desktop.nix
            ];
          }
          ++ cosmic-stuff;
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
          # Adding Hyprpanel overlay for the battleship machine
          ++ [
            {
              nixpkgs.overlays = [ hyprpanel.overlay ];
            }
          ];
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
          ] ++ home-manager-liperium-root {
            userImports = [
              ./home/console.nix
            ];
          };
        };
      };
    };
}
