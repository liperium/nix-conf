{ config, pkgs, lib, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false; # Or can't install boot loader

  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules.nix
  ];
  networking.hostName = "atlas";
  
  services.openssh = {
    enable = true;
    ports = [5252];
  };
}
