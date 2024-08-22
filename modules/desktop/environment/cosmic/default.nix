# Needs to have https://github.com/lilyinstarlight/nixos-cosmic upstream
{ config
, pkgs
, lib
, ...
}:
{
  services.pipewire = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-gtk
    nautilus
  ];
  services.desktopManager.cosmic.enable = true;
  hardware.system76.enableAll = true;
  services.power-profiles-daemon.enable = false; # Because we use system76-power
  boot.extraModulePackages =
    with config.boot.kernelPackages; [
      system76-scheduler
      system76-power
    ];
}
