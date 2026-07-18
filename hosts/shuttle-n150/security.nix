{ nixpkgs, conf, ... }:
let
  # Edit here when LAN changes; every downstream rule below picks it up.
  lanSubnet = "192.168.1.0/24";
  wgSubnet = "10.100.0.0/24";
in
{
  # Security
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80 # Caddy HTTP
      443 # Caddy HTTPS
      22 # SSH
      53 # DNS
      3053 # AdGuardHome web UI
      8080 # UniFi device inform (docker container)
    ];
    allowedUDPPorts = [
      51820 # Wireguard
      53 # DNS
      3478 # UniFi STUN
      10001 # UniFi device discovery
      1900 # UniFi L2 discovery (SSDP)
    ];
    trustedInterfaces = [ "wg0" ];
    # Trust any packet from LAN regardless of iface (WiFi, Ethernet, future renames).
    extraInputRules = ''
      ip saddr ${lanSubnet} accept
    '';
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";
    bantime-increment = {
      enable = true; # repeat offenders get longer bans
      maxtime = "168h"; # cap at 1 week
      factor = "4";
    };
  };
  # Define a custom filter for Caddy
  environment.etc."fail2ban/filter.d/caddy-status.conf".text = ''
    [Definition]
    failregex = ^.*"remote_ip":"<HOST>".*"status":(401|403|404).*$
    ignoreregex =
  '';

  services.fail2ban.jails = {
    caddy-status = {
      settings = {
        enabled = true;
        filter = "caddy-status";
        logpath = "/var/log/caddy/access.log";
        maxretry = 10;
        findtime = "10m";
        bantime = "1h";
        action = "iptables-multiport[name=caddy, port=\"http,https\"]";
      };
    };
  };
  services.fail2ban.ignoreIP = [
    "127.0.0.0/8"
    lanSubnet
    wgSubnet
  ];
}
