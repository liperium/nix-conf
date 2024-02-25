{ config, pkgs, ... }:

{
  home.file = {
        ".config/hypr/hyprpaper.conf".source = config.lib.file.mkOutOfStoreSymlink ./hyprpaper.conf;
    };
  home.packages = with pkgs;[hyprpaper hyprlang];
}