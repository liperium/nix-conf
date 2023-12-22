{ config, pkgs, lib, ... }:

{
  virtualisation.docker= {
    enable = true;
    storageDriver = "btrfs";
  };
  users.users.liperium.extraGroups = [ "docker" ];
  environment.systemPackages = with pkgs; [ docker docker-compose ];
}
