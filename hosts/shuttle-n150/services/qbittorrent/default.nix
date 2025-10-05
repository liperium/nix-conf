{ pkgs, config, ... }:
{
  services.qbittorrent = {
    enable = true;
    user = "liperium";
    group = "liperium";
    webuiPort = 8182;
    serverConfig = { };
  };
}
