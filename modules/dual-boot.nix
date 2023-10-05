{
  # Bootloader.
  boot.supportedFilesystems = ["ntfs"];
  #boot.loader.systemd-boot.enable = true;
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub.enable = true;
    grub.devices = ["nodev"];
    grub.efiSupport = true;
    grub.useOSProber = true;
  };
}