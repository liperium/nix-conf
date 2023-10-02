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
        nixos-lenovo = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/nixos-lenovo
          ];
        };

        #nixos-pc = lib.nixosSystem {
          #inherit system;
          #modules = [
            #./nixos-pc.nix
          #];
        #};
      };
    };
}
