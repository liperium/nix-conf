{ config, pkgs, ... }:

{
    home.file = {
        ".config/helix/config.toml".source = ./config.toml;
        ".config/helix/themes/catppuccin_mocha".source = .themes/catppuccin_mocha.toml
    };
    home.packages = with pkgs;[helix];
}