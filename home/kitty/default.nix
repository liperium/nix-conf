{ config, pkgs, ... }:

{
    home.file = {
        ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink ./kitty.conf;
    };
    home.packages = with pkgs;[kitty];
}