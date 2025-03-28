{ lib
, config
, pkgs
, ...
}:
let
  regreet-theme =
    (pkgs.catppuccin-gtk.override {
      variant = "mocha";
      accents = [ "mauve" ];
    });
in
{

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
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
    # Enable "Silent Boot"
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
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };

  # FW Update
  services.fwupd.enable = true;
  # Fingerprint
  services.fprintd.enable = true;

  # GDM
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # Autologin
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "liperium";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Ambiant light sensor
  hardware.sensor.iio.enable = true;

  services.openssh = {
    enable = true;
    ports = [ 22 ];
  };
  #services.upower.enable = true;
  environment.systemPackages = with pkgs;
    [
      fprintd
      polkit_gnome
      bitwarden-desktop
      nvtopPackages.intel
      # Hyprpanel
    ];
  #programs.bitwarden.enable = true;

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  #services.blueman.enable = true;

}
