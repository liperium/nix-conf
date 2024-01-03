{ config, pkgs, lib, ... }:

{
  qt = { 
    enable = true; 
    style = lib.mkForce "gtk2"; 
    platformTheme = lib.mkForce "gtk2"; 
  }; 
  users.users.liperium = {
    packages = with pkgs; [
      #Basic Needs
      firefox
      steam-run
      gparted
      vlc
      widevine-cdm
      galculator

      #Personnal
      qownnotes
      betterdiscordctl
      webcord
      discord
      xwaylandvideobridge
      thunderbird-bin
      qbittorrent

      #Media-Streams
      obs-studio
      chatterino2
      streamlink
      streamlink-twitch-gui-bin

      #Creative
      gimp
      kate
      krita
      libsForQt5.kdenlive

      #Misc
      spot
      nextcloud-client # ? cmd

      # Office
      onlyoffice-bin
      zoom-us
    ];
  };
  programs.dconf.enable = true; #Firefox cursor theme https://github.com/NixOS/nixpkgs/issues/207339#issuecomment-1747101887
  
  environment.systemPackages = with pkgs; [
    beauty-line-icon-theme
    papirus-icon-theme
  ];
}
