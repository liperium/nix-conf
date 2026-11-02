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
      url = "github:noctalia-dev/noctalia/cachix";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ai-usagebar = {
      url = "github:akitaonrails/ai-usagebar";
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
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    # Mapgears (private, desktop app, not a flake itself)
    khronos-go = {
      url = "git+ssh://git@proj.mapgears.com/diffusion/KHRONOSGO/khoronos-go.git";
      flake = false;
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
    { nixpkgs
    , home-manager
    , nixos-hardware
    , catppuccin
    , sops-nix
    , vpn-confinement
    , ...
    }@inputs:
    let
      system = "x86_64-linux";
      # hmImports: home-manager modules for liperium (root always gets home/root.nix)
      mkHost = { host, extraModules ? [ ], hmImports ? [ ./home/console.nix ] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/${host} ] ++ extraModules ++ [
            home-manager.nixosModules.home-manager
            ({ pkgs, ... }: {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.liperium.imports = hmImports ++ [
                  catppuccin.homeModules.catppuccin
                  inputs.noctalia.homeModules.default
                ];
                users.root = import ./home/root.nix;
                backupCommand = ''
                  ${pkgs.coreutils}/bin/mv -f "$1" "$1.hm_backup"
                '';
                extraSpecialArgs = { inherit system inputs; };
              };
            })
            sops-nix.nixosModules.sops
          ];
        };
    in
    {
      nixosConfigurations = {
        frigate = mkHost {
          host = "frigate";
          extraModules = [ nixos-hardware.nixosModules.framework-intel-core-ultra-series1 ];
          hmImports = [ ./home/niri.nix ];
        };
        battleship = mkHost {
          host = "battleship";
          hmImports = [ ./home/niri.nix ];
        };
        shuttle-n150 = mkHost {
          host = "shuttle-n150";
          extraModules = [ vpn-confinement.nixosModules.default ];
        };
      };
    };
}
