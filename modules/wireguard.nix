{ config
, pkgs
, lib
, ...
}:

{
  environment.systemPackages = with pkgs; [ wireguard-tools ];

  # From the wiki or else it's not working.
  networking.networkmanager.dns = "systemd-resolved";
  services.resolved.enable = true;
  networking.firewall.checkReversePath = false;
}
