{ config, pkgs, lib, ... }:
let
  nix-quick-update = pkgs.writeShellScriptBin "nix-quick-update" ''
    #!/bin/sh
    cd /home/liperium/nix-conf; 
    git pull; 
    nh os switch ./;
  '';
in
{
  environment.systemPackages = [ nix-quick-update ];
}
