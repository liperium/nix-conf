# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules.nix
    ];
  networking.hostName = "nixos-lenovo";

  # Bootloader.
  boot.supportedFilesystems = ["ntfs"];
  #boot.loader.systemd-boot.enable = true;
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub.enable = true;
    grub.devices = ["nodev"];
    grub.efiSupport = true;
    grub.useOSProber = true;
  };

  boot.kernelParams = [
    "acpi_backlight=native" #native/video/vendor, maybe depending if nvidia is installed?
  ];

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-12772946-336b-4704-bd68-6d21410cbd7e".device = "/dev/disk/by-uuid/12772946-336b-4704-bd68-6d21410cbd7e";
  boot.initrd.luks.devices."luks-12772946-336b-4704-bd68-6d21410cbd7e".keyFile = "/crypto_keyfile.bin";



  # --- Laptop settings ---
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
       governor = "powersave";
       turbo = "never";
    };
    charger = {
       governor = "performance";
       turbo = "auto";
    };
  };

  # Nvidia
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Do not disable this unless your GPU is unsupported or if you have a good reason to.
    open = true;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload.enable = true;
      # Make sure to use the correct Bus ID values for your system!
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
        {
          command = "${pkgs.coreutils}/bin/tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004\\:00/conservation_mode";
          options = [ "NOPASSWD" ];
        }
      ];
      groups = [ "wheel" ];
    }];
  };
}
