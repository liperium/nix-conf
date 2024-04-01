{ config, pkgs, lib, ... }:

{
  qt = {
    enable = true;
    style = lib.mkForce "gtk2";
    platformTheme = lib.mkForce "gtk2";
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "alt-intl";
  };
}
