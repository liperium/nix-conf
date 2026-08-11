{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./modules.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "battleship";

  environment.systemPackages = with pkgs; [
    nvtopPackages.amd
    gparted
    rkdeveloptool
    minicom
  ];
  virtualisation.waydroid.enable = true;
  virtualisation.waydroid.package = pkgs.waydroid-nftables;
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

    loader.timeout = 5;
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
    systemd-boot.enable = false;

    limine = {
      enable = true;
      efiSupport = true;
      # Editing entries at boot allows passing init=/bin/sh, i.e. free root.
      enableEditor = false;
      # The ESP is only 600M and each generation copies its kernel + initrd
      # into /boot/limine/kernels, so cap how many are kept.
      maxGenerations = 5;

      style.interface.branding = "battleship";

      # Windows sits on its own ESP (nvme0n1p1), which Limine does not
      # auto-discover, so chainload its boot manager by partition GUID.
      extraEntries = ''
        /Windows
            protocol: efi
            path: guid(b8aa925c-1c9a-4512-9e80-879b8a2aef72):/EFI/Microsoft/Boot/bootmgfw.efi
      '';
    };
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  services.upower.enable = true;

  system.stateVersion = "24.11";
}
