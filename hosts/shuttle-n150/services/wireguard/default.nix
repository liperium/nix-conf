{ pkgs, lib, ... }:
{
  networking.nat.enable = true;
  networking.nat.externalInterface = "enp1s0";
  networking.nat.internalInterfaces = [ "wg0" ];
  sops.secrets."wireguard/privatekey" = {
    sopsFile = ../../../../modules/secrets/wg-privatekey;
    format = "binary";
    owner = "root";
  };
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ "10.100.0.1/24" ];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 51820;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o end0 -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o end0 -j MASQUERADE
      '';

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/run/secrets/wireguard/privatekey";

      peers = [
        # List of allowed peers.
        {
          # Mattys Mobile          
          publicKey = "MuQSble61+N3axdIV6iqDTcbFQvtLkXRQ1h9R4Pug0s=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        {
          # Mattys Laptop 
          publicKey = "H33ZHf7AfxxRFZlHUmidwcf7YinHU3tLWuACl9Ag8iM=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
        {
          # Marie Mobile
          publicKey = "N2TjOH0mHwg9v1tO20jwC8ehg4ro5uZaBezorvFYwTs=";
          allowedIPs = [ "10.100.0.4/32" ];
        }
        {
          # Marie Laptop
          publicKey = "Ie9j51MuX90K7WVLYkHo3Y2av5NLRZzcf1qJQ1zYhA0=";
          allowedIPs = [ "10.100.0.5/32" ];
        }
      ];
    };
  };
}
