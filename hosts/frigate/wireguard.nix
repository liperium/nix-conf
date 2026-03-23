{ config, ... }:
{
  sops.secrets.frig-wg-priv = { };

  networking.wg-quick.interfaces.wg0 = {
    autostart = false;
    address = [ "10.100.0.3/24" ];
    dns = [ "192.168.0.15" ];
    privateKeyFile = config.sops.secrets.frig-wg-priv.path;

    peers = [
      {
        publicKey = "R9rxBPbIhcPyBMeFfe+dH86cdYMnZIWqThp6piR4z2A=";
        allowedIPs = [ "192.168.0.0/24" ];
        endpoint = "vpn.mattysgervais.com:51820";
        persistentKeepalive = 25;
      }
    ];
  };
}
