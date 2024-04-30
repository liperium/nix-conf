{ config, pkgs, lib, ... }:

{
  services.xserver.xkb = {
    layout = "us";
    variant = "alt-intl";
  };
}
