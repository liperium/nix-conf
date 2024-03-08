{ config, pkgs, lib, ... }:
let
  nix-quick-update = pkgs.writeShellScriptBin "nix-quick-update" ''
    #!/bin/sh
    rm /home/liperium/.gtkrc-2.0
    cd /home/liperium/nix-conf; 
    git pull; 
    sudo nixos-rebuild switch --flake /home/liperium/nix-conf;
  '';
in {
  environment.systemPackages = [ nix-quick-update ];
}
