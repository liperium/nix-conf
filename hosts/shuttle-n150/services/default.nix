{ pkgs, lib, ... }:
{
  # Module defined services
  imports = [
    ./caddy
    ./wireguard
    ./nextcloud
  ];
  services.adguardhome = {
    enable = true;
    settings = null;
  }; # 3000
  # Home Assistant
  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "esphome"
      "met"
      "radio_browser"
      "tplink"
      "matter"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = { };

      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [ "192.168.0.15" "127.0.0.1" ];
      };
    };
  };
  services.matter-server.enable = true; # Matter wattage plugs

  # Reverse DNS
  services.ddclient = {
    enable = true;
    configFile = "/var/lib/ddclient/ddclient.conf";
  };

  # Uptime Kuma
  services.uptime-kuma = {
    enable = true;
    settings = {
      UPTIME_KUMA_HOST = "0.0.0.0";
    };
  };
  # ARR
  services.prowlarr.enable = true; # 9696
  services.sonarr.enable = true; # 8989
  services.jellyfin.enable = true; # 8096
  services.jellyseerr.enable = true; # 5055

  services.immich.enable = true; # 2283

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


}
