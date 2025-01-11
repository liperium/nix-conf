{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules.nix
  ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  networking.hostName = "battleship"; 

  environment.systemPackages = with pkgs; [
    nvtopPackages.amd
    os-prober # Probes for windows for grub
  ];
  services.fstrim.enable = true;

  services.xserver = {
    enable = true; # services.xserver.enable = true
    displayManager = {
      gdm = {
        enable = true; # services.xserver.displayManager.gdm.enable = true
        wayland = true; # services.xserver.displayManager.gdm.wayland = true
      };
    };
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
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
