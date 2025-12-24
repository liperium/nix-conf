{ pkgs, lib, config, ... }:
{
  # Nextcloud config
 
  # OCC commands : sudo -i nextcloud-occ YOUR_OCC_COMMAND
  services.nginx.virtualHosts."localhost".listen = [ { addr = "127.0.0.1"; port = 8001; } ];
  services.nextcloud = {
    enable = true;
    configureRedis = true;
    package = pkgs.nextcloud31;
    extraApps = {
      inherit (pkgs.nextcloud31Packages.apps)
        mail
        calendar
        tasks
        contacts;
    };
    hostName = "localhost";
    datadir = "/zfs-data/nextcloud"; # Make sure /zfs-data is mounted as root (systemd stuff), and that ./nextcloud folder is owned by nextcloud
    config = {
      adminpassFile = "/run/secrets/nextcloud-admin-pass";
      dbtype = "sqlite";
    };
    settings = {
      trusted_domains = [
        "nextcloud.mattysgervais.com"
        "192.168.0.15" # Trust itself/calls from the proxy
      ];
      trusted_proxies = [ "192.168.0.15" "127.0.0.1" ]; # Needed to accept from proxy
      overwriteprotocol = "https"; # Needed to understand comm between proxy
      maxChunkSize = 100000000;
    };
    phpOptions =  { # https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/big_file_upload_configuration.html
      "post_max_size"=lib.mkForce "16G";
      "upload_max_filesize"=lib.mkForce"16G";
      "max_input_time"="3600";
      "max_execution_time"="3600";
    };
    caching.redis = true;
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
  sops.secrets."nextcloud-admin-pass" = {
    sopsFile = ../../../../modules/secrets/nextcloud-admin-pass;
    format = "binary";
    owner = "nextcloud";
  };

}
