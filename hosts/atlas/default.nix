{ config, pkgs, lib, ... }:

{
  efi.canTouchEfiVariables = false;
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules.nix
  ];
  networking.hostName = "atlas";
}
