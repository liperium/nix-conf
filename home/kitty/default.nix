{ config, pkgs, ... }:

{
    home.file = {
        ".config/kitty/kitty.conf".source =  ./kitty.conf;
    };
    home.packages = with pkgs;[kitty];
}