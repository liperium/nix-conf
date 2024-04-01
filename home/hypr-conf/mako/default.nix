{ config, pkgs, ... }:

{
  home.file = {
    ".config/mako/config".source = ./config;
  };
  home.packages = with pkgs;[ mako ];
}
