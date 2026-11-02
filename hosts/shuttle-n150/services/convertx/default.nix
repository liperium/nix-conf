{ pkgs, ... }:
{
  # ConvertX (hardcoded to port 3000)
  systemd.services.convertx = {
    description = "ConvertX file converter";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    environment = {
      ALLOW_UNAUTHENTICATED = "true";
    };
    serviceConfig = {
      ExecStart = "${pkgs.convertx}/bin/convertx";
      Restart = "on-failure";
      DynamicUser = true;
      StateDirectory = "convertx";
      WorkingDirectory = "/var/lib/convertx";
    };
  };
}
