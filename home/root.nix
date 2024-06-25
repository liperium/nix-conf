{ config, pkgs, ... }:


{
  imports = [
    # Everywhere
    ./zsh
    ./helix
    ./zellij
  ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = "root";
  home.homeDirectory = "/root";

  home.stateVersion = "23.11"; # Please read the comment before changing.
}
