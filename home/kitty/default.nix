{ config, pkgs, ... }:

{
    home.file = {
        ".config/kitty/kitty.conf".source = config.lib.file.mkOutOfStoreSymlink ./kitty.conf;
    };
    home.packages = with pkgs;[kitty];
}