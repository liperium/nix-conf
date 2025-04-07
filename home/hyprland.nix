{ config, pkgs, hyprMonitor, ... }:


{
  imports = [
    # Desktop
    ./desktop.nix
    ./console.nix

    ./hypr-conf
    ./kitty
  ];
  dconf.settings = {

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      icon-theme = "Papirus-Dark";
    };
  };
}
