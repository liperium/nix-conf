{ config, pkgs, lib, ... }:

{
  # Enable automatic login for the user.
  #services.xserver.displayManager.autoLogin.enable = true;
  #services.xserver.displayManager.autoLogin.user = "liperium";
  #services.xserver.displayManager.defaultSession = "plasmawayland";

  users.users.liperium = {
    packages = with pkgs; [
      flameshot
      github-desktop
      python3
      kate
      krita
      webcord
      qownnotes
      nextcloud-client#? cmd
      gparted      
      (vivaldi.override {
        proprietaryCodecs = true;
        enableWidevine = false;
        commandLineArgs = "--force-dark-mode";
      })
      vivaldi-ffmpeg-codecs
      widevine-cdm
    ];
  };
  environment.systemPackages = with pkgs; [
    beauty-line-icon-theme
    papirus-icon-theme
  ];
}
