{ config, pkgs, lib, ... }:

{

  # Enable the X11 windowing system
  services.xserver.enable = true;
  # Enable Hyprland
  programs.hyprland.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "alt-intl";
  };
  
}
