# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/95aeb476-f885-4694-9f9e-a640b7ecf063";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  boot.initrd.luks.devices."luks-397b9746-9090-4926-aafe-f51d52b42faa".device = "/dev/disk/by-uuid/397b9746-9090-4926-aafe-f51d52b42faa";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-7561ef5f-fb63-45cf-acc9-19d0275eceb3".device = "/dev/disk/by-uuid/7561ef5f-fb63-45cf-acc9-19d0275eceb3";
  boot.initrd.luks.devices."luks-7561ef5f-fb63-45cf-acc9-19d0275eceb3".keyFile = "/crypto_keyfile.bin";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/C996-55F1";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/c60eb5f3-86b1-4bad-8911-625cb8d8e139"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
