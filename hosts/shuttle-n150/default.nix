# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules.nix
      ./services
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "shuttle-n150";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
    networkmanager.enable = true;
    wireguard.enable = true;
    interfaces.enp1s0 = {
      ipv4.addresses = [{
        address = "192.168.0.15";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.0.1";
      interface = "enp1s0";
    };
  };

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  networking.firewall.enable = false;

  # ZFS 
  # basics
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "86e27f43";
  # Config
  boot.zfs.extraPools = [ "zfs-data" ];
  services.zfs.autoScrub.enable = true;
  services.zfs.zed.settings =
    {
      ZED_NTFY_TOPIC = "FkFtiV69AO4i21vg";
    };

  system.stateVersion = "25.05"; # Did you read the comment?

}
