{ config, pkgs, ... }:

{
    home.file = {
        ".config/rofi/config.conf".source = ./config.rasi;
    };
    home.packages = with pkgs;[rofi-wayland];
}