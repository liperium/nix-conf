{ config, pkgs, lib, ... }:
let
  currentDir = ./.;
  protonup-rs = pkgs.callPackage ./.../../pkgs/protonup-rs/default.nix {};
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
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
}