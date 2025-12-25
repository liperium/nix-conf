{ pkgs, lib, ... }:
{


  services.caddy = {
    enable = true;
    configFile = ./Caddyfile;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
      hash = "sha256-48Xq2tb8ruAl87IJNWlIQa6bLISmNic0LuMNAJO7/n0=";
    };
    environmentFile = "/run/secrets/caddy.env";
  };

  sops.secrets."caddy.env" = {
    sopsFile = ../../../../modules/secrets/caddy.env;
    format = "dotenv";
    owner = "caddy";
  };
}
