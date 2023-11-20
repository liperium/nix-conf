{
inputs = { 
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; 
  # Home Manager
  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  };

outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      frigate = lib.nixosSystem {
        inherit system;
        modules = [ ./hosts/frigate ];
      };

      battleship = lib.nixosSystem {
        inherit system;
        modules = [ 
          ./hosts/battleship
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.josiah = import ./home/default.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
  };
}
