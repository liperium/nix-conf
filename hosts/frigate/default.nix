# Based on (not exactly) :
# https://github.com/NixOS/nixos-hardware/blob/master/lenovo/ideapad/15arh05/default.nix

{ lib, config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules.nix
  ];
  networking.hostName = "frigate";

  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
  ];

  services.displayManager.defaultSession = "plasma";

  services.xserver.displayManager = {
    gdm = {
      enable = true;
    };
  };

  # --- Laptop settings ---
  
  boot = {
    kernelModules = [ "acpi_call" ];
    kernelParams = [
      "acpi_backlight=native" # native/video/vendor, maybe depending if nvidia is installed?
      "amd_pstate=active" # amd pstate - https://github.com/NixOS/nixos-hardware/blob/master/common/cpu/amd/pstate.nix
    ];
    initrd.kernelModules = [ "amdgpu" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };
  hardware.cpu.amd.updateMicrocode = true; # https://github.com/NixOS/nixos-hardware/blob/master/common/cpu/amd/default.nix

  #Power/Cooling
  services.power-profiles-daemon.enable = false; # Don't know why it enables itself

  services.thermald.enable = lib.mkDefault true;
  services.tlp.enable = true;
  # tlp defaults to "powersave", which doesn't exist on this laptop
  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";
  };

  # SSD
  services.fstrim.enable = lib.mkDefault true;

  # Nvidia
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.opengl.extraPackages = with pkgs; [
    vaapiVdpau
  ];

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];
  #services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;

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
