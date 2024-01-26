{ config, pkgs, lib, ... }:

{
  qt = { 
    enable = true; 
    style = lib.mkForce "gtk2"; 
    platformTheme = lib.mkForce "gtk2"; 
  };
  services.xserver = {
    layout = "us";
    xkbVariant = "alt-intl";
  };
}
