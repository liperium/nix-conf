{ config, pkgs, lib, ... }:
let
  nix-quick-update = pkgs.writeShellScriptBin "nix-quick-update" ''
    #!/bin/sh
    cd /home/liperium/nix-conf; 
    rm /home/liperium/.gtkrc-2.0
    git pull; 
    nh os switch ./;
  '';
in
{
  environment.systemPackages = [ nix-quick-update ];
}
