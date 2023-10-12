{ config, pkgs, lib, ... }:

{
  users.users.liperium = {
    packages = with pkgs; [
      sqldeveloper
    ];
  };
}