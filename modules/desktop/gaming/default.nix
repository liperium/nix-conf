{ config, pkgs, lib, ... }:

{
  users.users.liperium = {
    packages = with pkgs; [
      steam
      mangohud
      goverlay
      gamemode
      starsector
      {./protonup-rs}
    ];
  };
}