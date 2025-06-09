{ lib
, config
, pkgs
, inputs
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

  time.timeZone = lib.mkForce "Europe/Oslo";

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
  # FW Stuff
  # FW Update
  services.fwupd.enable = true;
  # Fingerprint
  services.fprintd.enable = true;
  # Ambiant light sensor
  hardware.sensor.iio.enable = true;
  # GDM
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # Autologin
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "liperium";
  services.displayManager.defaultSession = "hyprland";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;


  services.openssh = {
    enable = true;
    ports = [ 22 ];
  };
  #services.upower.enable = true;
  environment.systemPackages = with pkgs;
    [
      fprintd
      polkit_gnome
      nvtopPackages.intel
      # Hyprpanel
      bluez
      bluez-tools

      # Fix logseq??
      stable.logseq
      easyeffects
      jellyfin-media-player
      cockatrice
      rustdesk
    ];

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
  services.power-profiles-daemon.enable = true;
  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  # Hyprland/panel
  services.blueman.enable = true;
  services.upower.enable = true;

  services.xserver.desktopManager.gnome = {
    #enable = true;
    extraGSettingsOverridePackages = [ pkgs.mutter ];
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer']
    '';
  };
}
