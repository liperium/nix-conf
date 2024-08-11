{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    catppuccin.url = "github:catppuccin/nix";
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nixos-hardware
    , catppuccin
    , ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        frigate = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/frigate
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.liperium = {
                  imports = [
                    ./home/home.nix
                    catppuccin.homeManagerModules.catppuccin
                  ];
                };
                users.root = import ./home/root.nix;
                backupFileExtension = "hm_backup";
                extraSpecialArgs = {
                  inherit inputs;
                };
              };
            }
            # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
            nixos-hardware.nixosModules.lenovo-legion-15arh05h
          ];
        };

        battleship = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/battleship
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                imports = [
                  ./home/home.nix
                  catppuccin.homeManagerModules.catppuccin
                ];
                users.root = import ./home/root.nix;
                backupFileExtension = "hm_backup";
                extraSpecialArgs = {
                  inherit inputs;
                };
              };
            }
          ];
        };
        atlas = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/atlas ];
        };
      };
    };
}
