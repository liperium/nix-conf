{ pkgs, lib, inputs, ... }:
{
  # Module defined services
  imports = [
    ./caddy
    ./wireguard
    ./nextcloud
    ./jellyfin
    ./qbittorrent
    ./homer
    ./mtg-scraper
    ./authelia
    ./ml-production-website
    ./countdown
    ./construct3-hoster
    ./invoice-ninja
  ];
  services.adguardhome = {
    enable = true;
    port = 3053;
    settings = null;
  };

  # UniFi Network Application (jacobalberty image, MongoDB bundled).
  # Uses host networking so L2 device discovery (SSDP/broadcast) works.
  # Caddy reverse-proxies https://unifi.mur.mattysgervais.com -> https://127.0.0.1:8443.
  systemd.tmpfiles.rules = [
    "d /var/lib/unifi 0755 root root -"
  ];
  virtualisation.oci-containers.containers.unifi = {
    image = "jacobalberty/unifi:latest";
    autoStart = true;
    environment = {
      TZ = "America/Montreal";
      RUNAS_UID0 = "false";
      UNIFI_UID = "999";
      UNIFI_GID = "999";
    };
    volumes = [
      "/var/lib/unifi:/unifi"
    ];
    extraOptions = [
      "--network=host"
      "--dns=1.1.1.1"
      "--dns=8.8.8.8"
    ];
  };

  # Google Assistant service account, referenced from HA's configuration.yaml
  # as `!include SERVICE_ACCOUNT.json`. Bind-mounted into the container below.
  # Owned by root now that the native `hass` user no longer exists.
  sops.secrets."hass-google-service-account.json" = {
    sopsFile = ../../../modules/secrets/hass-google-service-account.json;
    format = "binary";
    path = "/var/lib/hass/SERVICE_ACCOUNT.json";
    owner = "root";
  };

  # Home Assistant (podman container).
  # Config lives in the `home-assistant` podman volume (/config). Restore your
  # backup there and re-run onboarding as needed.
  # Backend (docker) is set globally by the invoice-ninja module; inherit it.
  virtualisation.oci-containers = {
    containers.homeassistant = {
      image = "ghcr.io/home-assistant/home-assistant:stable";
      autoStart = true;
      # Note: the image is not updated on rebuilds unless the tag/version changes.
      volumes = [
        "home-assistant:/config"
        # Google Assistant service account (managed by sops), read-only.
        "/var/lib/hass/SERVICE_ACCOUNT.json:/config/SERVICE_ACCOUNT.json:ro"
      ];
      environment.TZ = "America/Montreal";
      extraOptions = [
        # Use the host network namespace so device discovery (SSDP/mDNS) works.
        "--network=host"
        # Pass USB devices (e.g. Zigbee/Z-Wave dongles) into the container.
        # A device that doesn't exist blocks startup, so uncomment/adjust only
        # if the shuttle actually has one.
        # "--device=/dev/ttyACM0:/dev/ttyACM0"
      ];
    };
  };
  services.matter-server.enable = true; # Matter wattage plugs

  # Reverse DNS
  services.ddclient = {
    enable = true;
    configFile = "/run/secrets/ddclient.conf";
  };
  sops.secrets."ddclient.conf" = {
    sopsFile = ../../../modules/secrets/ddclient.conf;
    format = "binary";
    owner = "root";
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
  services.sonarr.group = "users";
  services.radarr.enable = true; # 7878
  services.radarr.group = "users";
  services.flaresolverr.enable = true; # 8191
  services.jellyseerr.enable = true; # 5055
  services.bazarr.enable = true; # 6767
  services.bazarr.group = "users";

  # Ensure files/dirs created by *arr services are group-writable so
  # bazarr (same `users` group) can write subtitles next to videos.
  systemd.services.radarr.serviceConfig.UMask = "0002";
  systemd.services.sonarr.serviceConfig.UMask = "0002";
  systemd.services.bazarr.serviceConfig.UMask = "0002";
  systemd.services.bazarr.path = [ pkgs.mediainfo ];

  services.immich = {
    enable = true;
    package = pkgs.unstable.immich;
    port = 2283;
    host = "0.0.0.0";
    accelerationDevices = [ "/dev/dri/renderD128" ];
    mediaLocation = "/zfs-data/immich";
    settings.server.externalDomain = "https://immich.mattysgervais.com";
    settings.ffmpeg.accel = "qsv";
    settings.ffmpeg.accelDecode = true;
  };
  users.users.immich.extraGroups = [ "video" "render" ];

  users.users.marie = {
    isNormalUser = true;
    group = "users";
    home = "/zfs-data/marie";
    createHome = true;
  };

  # Stirling PDF
  services.stirling-pdf = {
    enable = true;
    environment = { SERVER_PORT = 6666; };
  };

  # ConvertX (hardcoded to port 3000)
  systemd.services.convertx = {
    description = "ConvertX file converter";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    environment = {
      ALLOW_UNAUTHENTICATED = "true";
    };
    serviceConfig = {
      ExecStart = "${pkgs.unstable.convertx}/bin/convertx";
      Restart = "on-failure";
      DynamicUser = true;
      StateDirectory = "convertx";
      WorkingDirectory = "/var/lib/convertx";
    };
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
        "server string" = "shuttle-n150";
        "netbios name" = "shuttle-n150";
        "hosts allow" = "192.168.0. 192.168.1. 10.0.0. 127.0.0.1 localhost";
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
      marie = {
        path = "/zfs-data/marie";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "writeable" = "yes";
        "valid users" = "marie";
        "force user" = "marie";
        "force group" = "users";
        "create mask" = "0664";
        "directory mask" = "0775";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  vpnNamespaces.qvpn = {
    # The name is limited to 7 characters
    enable = true;
    wireguardConfigFile = "/run/secrets/qvpn.conf";
    accessibleFrom = [ "192.168.0.0/16" "10.0.0.0/24" "127.0.0.1/32" "::1/128" ];
    portMappings = [{
      from = 8182;
      to = 8182;
      protocol = "tcp";
    }];
    openVPNPorts = [{
      port = 48026;
      protocol = "both"; # BitTorrent uses both TCP and UDP
    }];
  };
  sops.secrets."qvpn.conf" = {
    sopsFile = ../../../modules/secrets/qvpn.conf;
    format = "binary";
    owner = "root";
  };
  systemd.services.qbittorrent = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "qvpn";
    };
    after = [ "qvpn.service" ];
    requires = [ "qvpn.service" ];
  };
  systemd.services.pufferpanel = {
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      PrivateUsers = lib.mkForce false;
      User = "pufferpanel";
      Group = "pufferpanel";
    };
  };

  users.users.pufferpanel = {
    isSystemUser = true;
    group = "pufferpanel";
    home = "/var/lib/pufferpanel";
    createHome = true;
  };

  users.groups.pufferpanel = { };
  services.pufferpanel = {
    enable = true;
    extraPackages = with pkgs; [ bash curl gawk gnutar gzip depotdownloader jdk21 ];
    package = pkgs.buildFHSEnv {
      name = "pufferpanel-fhs";
      runScript = lib.getExe pkgs.pufferpanel;
      targetPkgs = pkgs': with pkgs'; [
        icu
        openssl
        zlib
        # Valheim
        libpulseaudio
        gccNGPackages_15.libatomic
        steamcmd
        glibc
        libgcc
        SDL2
        libGL
        xorg.libX11
        xorg.libXcursor
        xorg.libXrandr
        xorg.libXi
        xorg.libXext
        libxkbcommon
        dotnet-runtime
      ];
    };
    environment = {
      PUFFER_WEB_HOST = ":2556";
      PUFFER_PANEL_REGISTRATIONENABLED = "false";
    };
  };

  services.stash = {
    enable = true;
    username = "liperium";
    passwordFile = "/zfs-data/apps/stash/secrets/password";
    jwtSecretKeyFile = "/zfs-data/apps/stash/secrets/jwt-secret";
    sessionStoreKeyFile = "/zfs-data/apps/stash/secrets/session-key";
    settings.stash = [
      {
        path = "/zfs-data/apps/stash/videos";
        excludeimage = true;
      }
    ];
  };

}
