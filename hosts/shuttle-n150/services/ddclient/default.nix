{ ... }:
{
  # Reverse DNS
  services.ddclient = {
    enable = true;
    configFile = "/run/secrets/ddclient.conf";
  };
  sops.secrets."ddclient.conf" = {
    sopsFile = ../../../../modules/secrets/ddclient.conf;
    format = "binary";
    owner = "root";
  };
}
