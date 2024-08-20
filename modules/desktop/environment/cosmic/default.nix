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
  boot.extraModulePackages =
    with config.boot.kernelPackages; [
      system76-scheduler
      system76-power
    ];
}
