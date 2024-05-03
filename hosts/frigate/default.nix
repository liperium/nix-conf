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
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };

  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware; # https://github.com/NixOS/nixos-hardware/blob/master/common/cpu/amd/default.nix

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

  # AMD
  options.hardware.amdgpu.loadInInitrd = lib.mkEnableOption (lib.mdDoc
    "loading `amdgpu` kernelModule at stage 1. (Add `amdgpu` to `boot.initrd.kernelModules`)"
  ) // {
    default = true;
  };
  boot.initrd.kernelModules = [ "amdgpu" ];
  options.hardware.amdgpu.amdvlk = lib.mkEnableOption (lib.mdDoc
    "use amdvlk drivers instead mesa radv drivers"
  );
  options.hardware.amdgpu.opencl = lib.mkEnableOption (lib.mdDoc
    "rocm opencl runtime (Install rocmPackages.clr and rocmPackages.clr.icd)"
  ) // {
    default = true;
  };

  config = lib.mkMerge [
    {
      services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];

      hardware.opengl = {
        driSupport = lib.mkDefault true;
        driSupport32Bit = lib.mkDefault true;
      };
    }
    (lib.mkIf config.hardware.amdgpu.loadInInitrd {
      boot.initrd.kernelModules = [ "amdgpu" ];
    })
    (lib.mkIf config.hardware.amdgpu.amdvlk {
      hardware.opengl.extraPackages = with pkgs; [
        amdvlk
      ];

      hardware.opengl.extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    })
    (lib.mkIf config.hardware.amdgpu.opencl {
      hardware.opengl.extraPackages =
        if pkgs ? rocmPackages.clr
        then with pkgs.rocmPackages; [ clr clr.icd ]
        else with pkgs; [ rocm-opencl-icd rocm-opencl-runtime ];
    })
  ];

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
