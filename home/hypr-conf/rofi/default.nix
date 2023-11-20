{ config, pkgs, ... }:

{
    home.file = {
        ".config/rofi/config.conf".source = ./config.rasi;
    };
    programs.rofi-wayland.enable = true;
}