{ config, pkgs, ... }:

{
    home.file = {
        ".config/mako/config".source = config.lib.file.mkOutOfStoreSymlink ./config;
    };
    home.packages = with pkgs;[mako];
}