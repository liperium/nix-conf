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
    temurin-bin-17
    unzip
    zip
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [ 
      {from = 1000; to = 10000;}
      {from = 25565; to = 25570;}
    ];
    allowedUDPPortRanges = [
      {from = 1000; to = 10000;}
      {from = 25565; to = 25570;}
    ];
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
