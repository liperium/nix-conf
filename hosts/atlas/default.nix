{ config
, pkgs
, lib
, ...
}:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false; # Or can't install boot loader

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules.nix
  ];
  powerManagement.powertop.enable = true;

  networking.hostName = "atals";
  networking.firewall = {
    
    allowPing = true; # Samba?
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
  };

  environment.systemPackages = with pkgs; [
    zfs
    unzip
    zip

    # for now, need to make liperium home-manager user
    oh-my-posh
    zellij
  ];


  # ZFS

  # basics
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "86e27f43";

  # config
  boot.zfs.extraPools = [ "zfs-data" ];
  services.zfs.autoScrub.enable = true;
  services.zfs.zed.settings =
    {
      ZED_NTFY_TOPIC = "FkFtiV69AO4i21vg";
    };

  # Samba - need to setup a user for the private share
  # sudo smbpasswd -a myuser
  services.samba = {
    enable = true;

    openFirewall = true;
    settings = {
      global = {
        security = "user";
        "workgroup" = "WORKGROUP";
        "server string" = "atlas";
        "netbios name" = "atlas";
        "hosts allow" = "192.168.0. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      private = {
        path = "/zfs-data";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "writeable" = "yes";
        "inherit permissions" = "yes";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # Nextcloud config
  #environment.etc."nextcloud-admin-pass".text = "RANDOM_PASSWORD";
  # OCC commands : sudo -i nextcloud-occ YOUR_OCC_COMMAND
  services.nextcloud = {
    enable = true;
    configureRedis = true;
    package = pkgs.nextcloud30;
    hostName = "localhost";
    datadir = "/zfs-data/nextcloud"; # Make sure /zfs-data is mounted as root (systemd stuff), and that ./nextcloud folder is owned by nextcloud
    config = {
      adminpassFile = "/etc/nextcloud-admin-pass";
      dbtype = "sqlite";
    };
    settings = {
      trusted_domains = [
        "nextcloud.mattysgervais.com"
        "192.168.0.20" # Trust itself/calls from the proxy
      ];
      trusted_proxies = [ "192.168.0.10" ]; # Needed to accept from proxy
      overwriteprotocol = "https"; # Needed to understand comm between proxy
    };
    settings.enabledPreviewProviders = [
      "OC\\Preview\\BMP"
      "OC\\Preview\\GIF"
      "OC\\Preview\\JPEG"
      "OC\\Preview\\Krita"
      "OC\\Preview\\MarkDown"
      "OC\\Preview\\MP3"
      "OC\\Preview\\OpenDocument"
      "OC\\Preview\\PNG"
      "OC\\Preview\\TXT"
      "OC\\Preview\\XBitmap"
      "OC\\Preview\\HEIC"
    ];
  };
  services.nginx.virtualHosts."localhost".listen = [
    {
      addr = "0.0.0.0";
      port = 8002;
    }
  ];

  services.cron = {
    enable = true;
    systemCronJobs = [ "0 2 * * *      root    /opt/backup-hdpdb.sh" ];
  };
}
