{ lib
, config
, pkgs
, inputs
, ...
}:
{
  time.timeZone = lib.mkForce "America/Montreal";

  imports = [
    ../frigate/hardware-configuration.nix
    ./modules.nix
  ];

  networking.hostName = "frigate";
  networking.firewall.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-2a9c4cee-d3a3-41ce-9d46-f48a7cf2d703".device = "/dev/disk/by-uuid/2a9c4cee-d3a3-41ce-9d46-f48a7cf2d703";
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
    loader.timeout = 0;
  };

  # FW Update
  services.fwupd.enable = true;
  # Fingerprint
  services.fprintd.enable = true;

  services.displayManager.gdm.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "liperium";
  services.displayManager.defaultSession = "niri";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services.openssh = {
    enable = true;
    ports = [ 22 ];
  };

  environment.systemPackages = with pkgs; [
    fprintd
    polkit_gnome
    nvtopPackages.intel
    bluez
    bluez-tools
    unstable.code-cursor
    easyeffects
    omnissa-horizon-client
  ];

  services.power-profiles-daemon.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  services.upower.enable = true;
  system.stateVersion = "24.11";
}
