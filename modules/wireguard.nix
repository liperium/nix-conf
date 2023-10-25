{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [ wireguard-tools ];
}
