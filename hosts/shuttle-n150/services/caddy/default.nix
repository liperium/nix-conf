{ pkgs, lib, ... }:
{


  services.caddy = {
    enable = true;
    configFile = ./Caddyfile;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
      hash = "sha256-p9AIi6MSWm0umUB83HPQoU8SyPkX5pMx989zAi8d/74=";
    };
    environmentFile = "/run/secrets/caddy.env";
  };

  sops.secrets."caddy.env" = {
    sopsFile = ../../../../modules/secrets/caddy.env;
    format = "dotenv";
    owner = "caddy";
  };
}
