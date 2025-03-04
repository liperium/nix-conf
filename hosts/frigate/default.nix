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
      # Hyprpanel
    ];

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  #services.blueman.enable = true;

}
