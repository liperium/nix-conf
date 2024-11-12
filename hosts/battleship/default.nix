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
  services.fstrim.enable = true;

  # services.displayManager.defaultSession = "hyprland";
  # services.displayManager.cosmic-greeter.enable = true;
  services.xserver = {
    enable = true; # services.xserver.enable = true
    displayManager = { 
      gdm = {
        enable = true; # services.xserver.displayManager.gdm.enable = true
        wayland = true; # services.xserver.displayManager.gdm.wayland = true
      };
    };
  };
  # networking.firewall = {
  #   enable = true;
  #   allowedTCPPorts = [
  #     8080
  #     5252
  #     5173 # Svelte
  #     5037 # ADB
  #     8050 # Postgresql dev
  #   ];
  #   allowedUDPPorts = [
  #     8080
  #     5252
  #     5173 # Svelte
  #     5353 # ADB
  #     8050 # Postgresql dev
  #   ];
  # };
  services.openssh = {
    enable = true;
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
