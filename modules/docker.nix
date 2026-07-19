{ config
, pkgs
, lib
, ...
}:

{
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_29;
  };
  users.users.liperium.extraGroups = [ "docker" ];
  environment.systemPackages = with pkgs; [
    docker_29
    docker-compose
  ];
}
