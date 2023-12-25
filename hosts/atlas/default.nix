{ config, pkgs, lib, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false; # Or can't install boot loader

  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules.nix
  ];
  networking.hostName = "atlas";

  services.openssh = {
    enable = true;
    ports = [5252];
  };

  environment.systemPackages = with pkgs; [
    zfs
  ];

  networking = {
    interfaces.eno1.useDHCP = false;
    interfaces.eno1.ipv4.addresses = [{
      address = "192.168.0.20";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.0.1";
    nameservers = [ "192.168.0.10" ];
  };

  # ZFS

  # basics
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "86e27f43";

  # config
  boot.zfs.extraPools = [ "zfs-data" ];
  services.zfs.autoScrub.enable = true;
}
