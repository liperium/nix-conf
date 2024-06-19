{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules.nix
  ];
  networking.hostName = "frigate";

  services.displayManager.defaultSession = "plasma";

  services.xserver.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
      settings = {
        Autologin = {
          Session = "plasma.desktop";
          User = "liperium";  
        };
      };
    };
  };

  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings.CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
}
