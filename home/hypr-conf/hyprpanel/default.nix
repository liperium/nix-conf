{ config, pkgs, ... }:
{
  home.packages = with pkgs;[
    hyprpanel
    hyprpicker
  ];
}
