{ config, pkgs, inputs, ... }:
let
  url = "https://cache.mur.mattysgervais.com";
in
{
  # Attic cache on shuttle-n150 (LAN/WireGuard only).
  nix.settings = {
    extra-substituters = [ "${url}/main" ];
    extra-trusted-public-keys = [ "main:d4YVKG7mWhIVg8xaPjWffaZKSBPM4VH5otFfBOj+hsI=" ];
    # Off-VPN the cache is unreachable: fail fast and build/fetch elsewhere.
    connect-timeout = 5;
    fallback = true;
  };

  environment.systemPackages = [ pkgs.attic-client ];

  sops.secrets."attic-push-token" = {
    sopsFile = "${inputs.self}/modules/secrets/attic-push-token";
    format = "binary";
  };

  # Push everything this machine builds so the other desktop can substitute it.
  systemd.services.attic-watch-store = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    environment.HOME = "/var/lib/attic-watch-store";
    path = [ pkgs.attic-client ];
    script = ''
      attic login home ${url} "$(cat ${config.sops.secrets."attic-push-token".path})"
      exec attic watch-store home:main
    '';
    serviceConfig = {
      StateDirectory = "attic-watch-store";
      Restart = "always";
      RestartSec = 60;
    };
  };
}
