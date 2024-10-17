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
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nixos-hardware
    , catppuccin
    , nixos-cosmic
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
      home-manager-liperium-root = [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.liperium = {
              imports = [
                ./home/desktop.nix
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
      ];
    in
    {
      nixosConfigurations = {
        frigate = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/frigate
            # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
            nixos-hardware.nixosModules.lenovo-legion-15arh05h
          ]
          ++ home-manager-liperium-root
          # Testing Cosmic
          ++ cosmic-stuff;
        };

        battleship = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/battleship
          ]
          ++ home-manager-liperium-root
          # Testing Cosmic
          ++ cosmic-stuff;
        };
        atlas = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/atlas ];
        };
      };
    };
}
