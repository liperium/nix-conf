{ config
, pkgs
, lib
, ...
}:
let
  protonup-rs = pkgs.callPackage ./protonup-rs/default.nix { };
in
{
  # Tools
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  users.users.liperium = {
    packages = with pkgs; [
      # Tools
      mangohud
      goverlay
      #protonup-rs
      # 
      # Wine
      wineWowPackages.waylandFull
      winetricks

      # Launchers
      lutris
      (heroic.override {
        extraPkgs = pkgs: [
          pkgs.gamemode
        ];
      })

      # Games
      prismlauncher
      temurin-bin-8
      temurin-bin-17
      wowup-cf
      starsector
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
    gamescopeSession.enable = true;
  };
}
