{ pkgs, lib, ... }:
{


  services.caddy = {
    enable = true;
    configFile = ./Caddyfile;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
      hash = "sha256-Rw2zrODQE1Ljgb4FenqUb3LmaNQUTp7h2/tXyjufClY=";
    };
    environmentFile = "/run/secrets/caddy.env";
  };

  sops.secrets."caddy.env" = {
    sopsFile = ../../../../modules/secrets/caddy.env;
    format = "dotenv";
    owner = "caddy";
  };
}
