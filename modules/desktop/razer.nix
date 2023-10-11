{ config, pkgs, lib, ... }:

{
  users.users.liperium = {
    packages = with pkgs; [
      
    ];
  };
  environment.systemPackages = with pkgs; [
    polychromatic
  ];
}
