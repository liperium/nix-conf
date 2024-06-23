{ config
, pkgs
, lib
, ...
}:
{
  # Bootloader.
  boot.supportedFilesystems = [ "ntfs" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
