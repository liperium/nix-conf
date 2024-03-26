{ config, pkgs, ... }:

{
  home.file = {
        ".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
    };
  home.packages = with pkgs;[hyprpaper];
}