{ config, pkgs, lib, ... }:

{
  users.users.liperium = {
    packages = with pkgs; [
      firefox-bin
      github-desktop
      gimp
      kate
      libsForQt5.kcalc
      krita
      onlyoffice-bin
      obs-studio
      libsForQt5.kdenlive
      zoom-us
      webcord
      qownnotes
      nextcloud-client # ? cmd
      gparted
      spot
      steam-run
      thundebird-bin
      (vivaldi.override {
        proprietaryCodecs = true;
        enableWidevine = false;
        commandLineArgs = "--force-dark-mode";
      })
      vivaldi-ffmpeg-codecs
      qbittorrent
      vlc
      widevine-cdm
    ];
  };
  
  environment.systemPackages = with pkgs; [
    beauty-line-icon-theme
    papirus-icon-theme
  ];
}
