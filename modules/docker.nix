{ config
, pkgs
, lib
, ...
}:

{
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_29;
    # Docker's default pools (172.17-172.31/16) collide with the RFC1918 space
    # hotel/conference/corp DHCP hands out. A bridge holding the same IP as the
    # network's gateway makes the kernel route gateway traffic to lo and kills
    # the uplink. Keep every bridge in a range nobody else uses.
    daemon.settings = {
      bip = "10.200.0.1/24";
      default-address-pools = [
        { base = "10.201.0.0/16"; size = 24; }
        { base = "10.202.0.0/16"; size = 24; }
      ];
    };
  };
  users.users.liperium.extraGroups = [ "docker" ];
  environment.systemPackages = with pkgs; [
    docker_29
    docker-compose
  ];
}
