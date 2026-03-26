{nixpkgs,conf,...}:
{
  # Security
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80    # Caddy HTTP
      443   # Caddy HTTPS
      22    # SSH
      53    # DNS
    ];
    allowedUDPPorts = [
      51820 # Wireguard
      53    # DNS
    ];
    trustedInterfaces = [ "wg0" "enp1s0" ];
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";
    bantime-increment = {
      enable = true;       # repeat offenders get longer bans
      maxtime = "168h";    # cap at 1 week
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
    "192.168.0.0/24"      # your LAN
    "10.100.0.0/24"       # your WireGuard subnet
  ];
}
