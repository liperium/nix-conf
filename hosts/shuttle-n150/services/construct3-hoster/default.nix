{ inputs, pkgs, ... }:
{
  systemd.services.construct3-hoster = {
    description = "Construct3 game hoster";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    environment = {
      PORT = "3010";
      PROJECTS_DIR = "/zfs-data/construct3-projects";
    };
    serviceConfig = {
      ExecStart = "${inputs.construct3-hoster.packages.${pkgs.system}.default}/bin/construct3-hoster";
      Restart = "on-failure";
      User = "liperium";
    };
  };
}
