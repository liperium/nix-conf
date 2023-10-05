{ config, pkgs, lib, ... }:
let
  currentDir = ./.;
  protonup-rs = pkgs.callPackage ././protonup-rs.nix {};
in {
  users.users.liperium = {
    packages = with pkgs; [
      steam
      mangohud
      goverlay
      gamemode
      starsector
      protonup-rs
    ];
  };
}