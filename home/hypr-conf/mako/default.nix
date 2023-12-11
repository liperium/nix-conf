{ config, pkgs, ... }:

{
    home.file = {
        ".config/waybar/config".source = config.lib.file.mkOutOfStoreSymlink ./config;
    };
    home.packages = with pkgs;[mako];
}