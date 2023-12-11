{ config, pkgs, ... }:

{
    home.file = {
        ".config/wlogout/layout".source = config.lib.file.mkOutOfStoreSymlink ./layout;
        ".config/wlogout/style.css".source = config.lib.file.mkOutOfStoreSymlink ./style.css;
    };
    home.packages = with pkgs;[wlogout];
}