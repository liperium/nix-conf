{ pkgs, config, ... }:
{
  services.qbittorrent = {
    enable = true;
    user = "liperium";
    group = "1000";
    webuiPort = 8182;
    serverConfig = { };
  };
}
