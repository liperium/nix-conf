{ pkgs, config, ... }:
{
  services.nzbget = {
    enable = true;
    group = "users";
    settings = {
      ControlPort = 6789;
      MainDir = "/zfs-data/nzb";
    };
  };
}
