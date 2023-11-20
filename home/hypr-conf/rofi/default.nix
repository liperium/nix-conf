{ config, pkgs, ... }:

{
    home.file = {
        ".config/rofi/config.conf".source = ./config.rasi;
        ".local/share/rofi/themes/catppuccin-macchiato-liperium.rasi".source = ./catppuccin-macchiato-liperium.rasi;
    };
    home.packages = with pkgs;[rofi-wayland];
}