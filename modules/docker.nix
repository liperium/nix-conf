{ config, pkgs, lib, ... }:

{
  virtualisation.docker.enable = true;
  users.users.liperium.extraGroups = [ "docker" ];
  virtualisation.docker.storageDriver = "btrfs";
  environment.systemPackages = with pkgs; [
      docker
      docker-compose
  ];
}