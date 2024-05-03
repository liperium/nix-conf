{ config, pkgs, lib, ... }:
let
  nix-quick-update = pkgs.writeShellScriptBin "nix-quick-update" ''
    #!/bin/sh
    rm /home/liperium/.gtkrc-2.0
    cd /home/liperium/nix-conf; 
    git pull; 
    nh os switch ./;
  '';
in
{
  environment.systemPackages = [ nix-quick-update ];
}
