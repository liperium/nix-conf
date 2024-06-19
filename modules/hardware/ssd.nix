# SSD
{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.fstrim.enable = lib.mkDefault true;
}
