{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ helix ];
}
