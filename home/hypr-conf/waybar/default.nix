{ config, pkgs, ... }:

{
    home.file = {
        ".config/waybar/config.jsonc".source = ./config.jsonc;
        ".config/waybar/macchiato.css".source = ./macchiato.css;
        ".config/waybar/style.css".source = ./style.css;
    };
    programs.rofi-wayland.enable = true;
}