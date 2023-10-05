{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        frigate = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/frigate
          ];
        };

        battleship = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/battleship
          ];
        };
      };
    };
}
