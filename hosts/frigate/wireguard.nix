{ config, ... }:
{
  sops.secrets.frig-wg-priv = { };

  networking.wg-quick.interfaces.wg0 = {
    address = [ "10.100.0.3/24" ];
    dns = [ "192.168.0.15" ];
    privateKeyFile = config.sops.secrets.frig-wg-priv.path;

    peers = [
      {
        publicKey = "R9rxBPbIhcPyBMeFfe+dH86cdYMnZIWqThp6piR4z2A=";
        allowedIPs = [ "0.0.0.0/0" ];
        endpoint = "vpn.mattysgervais.com:51820";
      }
    ];
  };
}
