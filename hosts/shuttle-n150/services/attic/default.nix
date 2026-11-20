{ ... }:
{
  # Binary cache for the desktops (LAN/WireGuard only via cache.mur).
  services.atticd = {
    enable = true;
    environmentFile = "/run/secrets/attic.env";
    settings = {
      listen = "127.0.0.1:8199";
      api-endpoint = "https://cache.mur.mattysgervais.com/";
      garbage-collection.default-retention-period = "3 months";
      chunking = {
        nar-size-threshold = 64 * 1024;
        min-size = 16 * 1024;
        avg-size = 64 * 1024;
        max-size = 256 * 1024;
      };
    };
  };

  sops.secrets."attic.env" = {
    sopsFile = ../../../../modules/secrets/attic.env;
    format = "dotenv";
  };
}
