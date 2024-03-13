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
    allowPing = true; # Samba?
  };

  # ZFS

  # basics
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "86e27f43";

  # config
  boot.zfs.extraPools = [ "zfs-data" ];
  services.zfs.autoScrub.enable = true;

  # Samba - need to setup a user for the private share
  # sudo smbpasswd -a myuser
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = atlas
      netbios name = atlas
      security = user 
      #use sendfile = yes
      #max protocol = smb2
      # note: localhost is the ipv6 localhost ::1
      hosts allow = 192.168.0. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      private = {
        path = "/zfs-data";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "no";
        "inherit permissions" = "yes";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
