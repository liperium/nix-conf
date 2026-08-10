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
      hash = "sha256-F7d4HwM4oCkQrFMr4SFSC0r52ONxY+PW6z5BJawW8Ok=";
    };
    environmentFile = "/run/secrets/caddy.env";
  };

  sops.secrets."caddy.env" = {
    sopsFile = ../../../../modules/secrets/caddy.env;
    format = "dotenv";
    owner = "caddy";
  };
}
