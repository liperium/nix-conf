{ config, pkgs, lib, ... }:
let
  prsDir = /home/liperium/Programming/Personnal/Protonup-rs;
  protonup-rs = pkgs.callPackage {$prsDir}/default.nix {}
in {
  users.users.liperium = {
    packages = with pkgs; [ protonup-rs ];
  };
}
