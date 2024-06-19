{
  config,
  pkgs,
  lib,
  dconf,
  ...
}:

{
  # sudo virsh net-start default
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  environment.systemPackages = with pkgs; [ qemu ];
  users.users.liperium.extraGroups = [ "libvirtd" ];
}
