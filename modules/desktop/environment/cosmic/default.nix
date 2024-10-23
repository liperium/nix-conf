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
    nautilus
  ];
  services.desktopManager.cosmic.enable = true;
}
