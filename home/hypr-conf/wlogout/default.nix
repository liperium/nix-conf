{ config, pkgs, ... }:

{
    home.file = {
        ".config/wlogout/layout".source = ./layout;
        ".config/wlogout/style.css".source = ./style.css;
    };
    home.packages = with pkgs;[wlogout];
}