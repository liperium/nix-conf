{ lib
, config
, pkgs
, ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules.nix
  ];
  networking.hostName = "frigate";

  #services.displayManager.defaultSession = "cosmic";
  #services.displayManager.cosmic-greeter.enable = true;

  #programs.hyprland.withUWSM = true;

  services.xserver = {
    enable = true; # services.xserver.enable = true
    displayManager = {
      gdm = {
        enable = true; # services.xserver.displayManager.gdm.enable = true
        wayland = true; # services.xserver.displayManager.gdm.wayland = true
      };
    };
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
  };

  # services.xserver.displayManager = {
  #   sddm = {
  #     enable = true;
  #     wayland.enable = true;
  #     autoNumlock = true;
  #     settings = {
  #       Autologin = {
  #         Session = "plasma.desktop";
  #         User = "liperium";
  #       };
  #     };
  #   };
  # };

  services.upower.enable = true;
  environment.systemPackages = with pkgs;
    [
      # Hyprpanel
      upower
      bluez
      bluez-tools
      dart-sass
      brightnessctl
      # powertop
    ];

  # Doesn't work on AMD
  services.power-profiles-daemon.enable = false;
  # services.tlp = {
  #   enable = true;
  #   settings.CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";
  #   settings.CPU_SCALING_GOVERNOR_ON_AC = "performance";
  # };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  services.blueman.enable = true;


  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;
    powerManagement.finegrained = false;

    open = false;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = lib.mkOverride 990 true;
        enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.offload.enable true; # Provides `nvidia-offload` command.
      };
      # Make sure to use the correct Bus ID values for your system!
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
