{ config, pkgs, lib, ... }:

{
  users.users.liperium = {
    packages = with pkgs; [
      #firefox
      github-desktop
      gimp
      kate
      libsForQt5.kcalc
      krita
      onlyoffice-bin
      obs-studio
      chatterino2
      libsForQt5.kdenlive
      zoom-us
      webcord
      qownnotes
      nextcloud-client # ? cmd
      gparted
      spot
      steam-run
      thunderbird-bin
      qbittorrent
      vlc
      widevine-cdm
    ];
  };
  # Firefox stuff
  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };
  programs.dconf.enable = true; #Firefox cursor theme https://github.com/NixOS/nixpkgs/issues/207339#issuecomment-1747101887
  
  environment.systemPackages = with pkgs; [
    beauty-line-icon-theme
    papirus-icon-theme
  ];
}
