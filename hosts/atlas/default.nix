{ config, pkgs, lib, ... }:

{
  boot.loader.efi.canTouchEfiVariables = false; # Or can't install boot loader
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules.nix
  ];
  networking.hostName = "atlas";
}
