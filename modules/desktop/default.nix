{ config, pkgs, lib, ... }:

{
  users.users.liperium = {
    packages = with pkgs; [
      github-desktop
      gimp
      kate
      libsForQt5.kcalc
      krita
      onlyoffice-bin
      zoom-us
      webcord
      qownnotes
      nextcloud-client#? cmd
      gparted      
      spot
      (vivaldi.override {
        proprietaryCodecs = true;
        enableWidevine = false;
        commandLineArgs = "--force-dark-mode";
      })
      vivaldi-ffmpeg-codecs
      vlc
      widevine-cdm
    ];
  };
  environment.systemPackages = with pkgs; [
    beauty-line-icon-theme
    papirus-icon-theme
  ];
}
