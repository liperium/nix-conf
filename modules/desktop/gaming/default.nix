{ config
, pkgs
, lib
, ...
}:
let
  protonup-rs = pkgs.callPackage ./protonup-rs/default.nix { };
in
{
  programs.gamemode.enable = true;

  programs.gamescope.enable = true;
  programs.steam.gamescopeSession.enable = true;
  users.users.liperium = {
    packages = with pkgs; [
      mangohud
      goverlay
      lutris
      steam
      #protonup-rs
      starsector
      prismlauncher
      wowup-cf
      temurin-bin-8
      wineWowPackages.waylandFull
      winetricks
      (heroic.override {
        extraPkgs = pkgs: [
          pkgs.gamemode
        ];
      })
    ];
  };
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs =
        pkgs: with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
    };
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
}
