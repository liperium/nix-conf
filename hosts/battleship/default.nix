# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules.nix
  ];

  networking.hostName = "battleship"; # Define your hostname.

  environment.systemPackages = with pkgs; [ 
    nvtop-amd
    path-of-building
  ];
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      5252
    ];
    allowedUDPPorts = [
      5252
    ];
  };
  services.openssh = {
    enable = true;
    ports = [5252];
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };
}
