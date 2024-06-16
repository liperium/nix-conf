# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules.nix
  ];

  networking.hostName = "battleship"; # Define your hostname.

  environment.systemPackages = with pkgs; [
    nvtopPackages.amd
    path-of-building
    os-prober # Probes for windows for grub
  ];

  services.displayManager.defaultSession = "plasma";
  services.xserver.displayManager = {

    #gdm = {
    #  enable = true;
    #  wayland = true;
    #};
    sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
      settings = {
        Autologin = {
          Session = "plasma.desktop";
          User = "liperium";
        };
      };
    };
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8080
      5252
      5037 #ADB
      8050 #Postgresql dev
    ];
    allowedUDPPorts = [
      8080
      5252
      5353 #ADB
      8050 #Postgresql dev
    ];
  };
  services.openssh = {
    enable = true;
    ports = [ 5252 ];
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };

  #Dual boot, systemd can't see other EFI partition, use grub instead
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub.enable = true;
    grub.devices = [ "nodev" ];
    grub.efiSupport = true;
    grub.useOSProber = true;
  };
}
