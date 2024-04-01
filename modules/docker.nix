{ config, pkgs, lib, ... }:

{
  virtualisation.docker = {
    enable = true;
  };
  users.users.liperium.extraGroups = [ "docker" ];
  environment.systemPackages = with pkgs; [ docker docker-compose ];
}
