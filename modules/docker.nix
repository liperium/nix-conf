{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
      docker
      docker-compose
  ]
}