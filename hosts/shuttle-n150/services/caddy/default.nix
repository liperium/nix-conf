{ pkgs, lib, inputs, ... }:
let
  caddyPkgs = import inputs.nixpkgs-caddy {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (pkgs) config;
  };
in
{
  services.caddy = {
    enable = true;
    configFile = ./Caddyfile;
    package = caddyPkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
      hash = "sha256-B5xXld1+IRUAQHm8zkHFqvRp8cqnervVL6XEos5VNkc=";
    };
    environmentFile = "/run/secrets/caddy.env";
  };

  sops.secrets."caddy.env" = {
    sopsFile = ../../../../modules/secrets/caddy.env;
    format = "dotenv";
    owner = "caddy";
  };
}
