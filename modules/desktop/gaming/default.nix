{ config, pkgs, lib, ... }:
let
  currentDir = ./.;
in {
  users.users.liperium = {
    packages = with pkgs; [
      steam
      mangohud
      goverlay
      gamemode
      starsector
      
    ];
  };
  imports =
    [ 
      # Base
      "${currentDir}/protonup-rs.nix"
    ];
}