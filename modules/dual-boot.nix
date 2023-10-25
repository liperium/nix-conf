{ config, pkgs, lib, ... }: {
  # Bootloader.
  boot.supportedFilesystems = [ "ntfs" ];
  #boot.loader.systemd-boot.enable = true;
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub.enable = true;
    grub.devices = [ "nodev" ];
    grub.efiSupport = true;
    grub.useOSProber = true;
  };
  environment.systemPackages = with pkgs;
    [
      os-prober # Probes for windows for grub
    ];
}
