{ ... }:
{
  # Shared VPN namespace; services opt in with systemd.services.<name>.vpnConfinement.
  vpnNamespaces.qvpn = {
    # The name is limited to 7 characters
    enable = true;
    wireguardConfigFile = "/run/secrets/qvpn.conf";
    accessibleFrom = [ "192.168.0.0/16" "10.0.0.0/24" "127.0.0.1/32" "::1/128" ];
    portMappings = [
      {
        from = 8182;
        to = 8182;
        protocol = "tcp";
      }
      {
        from = 6789;
        to = 6789;
        protocol = "tcp";
      }
    ];
    openVPNPorts = [{
      port = 48026;
      protocol = "both"; # BitTorrent uses both TCP and UDP
    }];
  };
  sops.secrets."qvpn.conf" = {
    sopsFile = ../../../../modules/secrets/qvpn.conf;
    format = "binary";
    owner = "root";
  };
}
