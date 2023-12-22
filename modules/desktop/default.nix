{ config, pkgs, lib, ... }:

{
  qt = { 
    enable = true; 
    style = lib.mkForce "gtk2"; 
    platformTheme = lib.mkForce "gtk2"; 
  }; 
  users.users.liperium = {
    packages = with pkgs; [
      firefox
      libsForQt5.polkit-kde-agent
      github-desktop
      gimp
      kate
      krita
      onlyoffice-bin
      obs-studio
      chatterino2
      galculator
      libsForQt5.kdenlive
      zoom-us
      webcord
      discord
      qownnotes
      nextcloud-client # ? cmd
      gparted
      spot
      steam-run
      thunderbird-bin
      qbittorrent
      xwaylandvideobridge
      vlc
      widevine-cdm
    ];
  };
  programs.dconf.enable = true; #Firefox cursor theme https://github.com/NixOS/nixpkgs/issues/207339#issuecomment-1747101887
  
  environment.systemPackages = with pkgs; [
    beauty-line-icon-theme
    papirus-icon-theme
  ];
}
