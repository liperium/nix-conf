{ config, pkgs, ... }:

{
    home.file = {
        ".config/waybar/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink ./config.jsonc;
        ".config/waybar/macchiato.css".source = config.lib.file.mkOutOfStoreSymlink ./macchiato.css;
        ".config/waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink ./style.css;
    };
    home.packages = with pkgs;[waybar];
}