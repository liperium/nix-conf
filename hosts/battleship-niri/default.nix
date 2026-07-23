{ config, pkgs, ... }:
{
  imports = [
    ../battleship/hardware-configuration.nix
    ./modules.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "battleship";

  environment.systemPackages = with pkgs; [
    nvtopPackages.amd
    os-prober
    (catppuccin-grub.override {
      flavor = "mocha";
    })
    gparted
    rkdeveloptool
    minicom
  ];
  programs.kdeconnect.enable = true;
  programs.kdeconnect.package = pkgs.kdePackages.kdeconnect-kde;

  services.flatpak.enable = true;

  boot = {
    plymouth = {
      enable = true;
      theme = "bgrt";
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    loader = {
      timeout = 5;
      grub.theme = "${pkgs.catppuccin-grub}";
    };
  };

  services.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "niri";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  services.power-profiles-daemon.enable = true;

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub.enable = true;
    grub.devices = [ "nodev" ];
    grub.efiSupport = true;
    grub.useOSProber = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  services.upower.enable = true;

  system.stateVersion = "24.11";
}
