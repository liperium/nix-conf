{ config, pkgs, lib, ... }:
let
  currentDir = ./.;
  protonup-rs = pkgs.callPackage ./protonup-rs/default.nix { };
in
{
  programs.gamemode.enable = true;
  users.users.liperium = {
    packages = with pkgs; [
      gamescope
      mangohud
      goverlay
      lutris
      steam
      starsector
      protonup-rs
      prismlauncher
    ];

  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
  };
}
