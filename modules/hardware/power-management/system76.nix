# Needs to have https://github.com/lilyinstarlight/nixos-cosmic upstream
{ config
, pkgs
, lib
, ...
}:
{
  hardware.system76.enableAll = true;
  services.power-profiles-daemon.enable = false; # Because we use system76-power
  boot.extraModulePackages =
    with pkgs; [
      system76-scheduler
      system76-power
    ];
}
