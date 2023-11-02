{ config, pkgs, lib, ... }:

{
  # Enable the X11 windowing system - Configure keymap in X11
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "alt-intl";
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  #wayland.windowManager.hyprland.settings = {
  #};

  environment.systemPackages = with pkgs; [
    kitty
    libsecret
    
    libsForQt5.dolphin
    
  ];
}
