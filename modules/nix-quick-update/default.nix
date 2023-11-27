{ config, pkgs, lib, ... }:
let
  nix-quick-update = pkgs.writeShellScriptBin "nix-quick-update" ''
    #!/bin/sh
    cd /home/liperium/nix-conf; 
    git pull; 
    sudo nixos-rebuild switch --flake /home/liperium/nix-conf;
  '';
in {
  environment.systemPackages = [ nix-quick-update ];
}
