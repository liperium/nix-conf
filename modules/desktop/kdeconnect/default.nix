{ config, pkgs, ... }:

{
  programs.kdeconnect.enable = true;

  networking.firewall = {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # kde connect
      {
        from = 5252;
        to = 5252;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # kde connect
      {
        from = 5252;
        to = 5252;
      }
    ];
  };
}
