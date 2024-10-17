{ config, pkgs, ... }:


{
  imports = [
    # Desktop
    ./desktop.nix
    ./all.nix

    ./hypr-conf
    ./kitty
  ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = "liperium";
  home.homeDirectory = "/home/liperium";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    #Theming
    papirus-icon-theme
  ];
}
