{ config
, pkgs
, lib
, ...
}:

{
  programs.adb.enable = true;
  users.users.liperium = {
    packages = with pkgs; [
      #sqldeveloper
      jetbrains.datagrip
      #jetbrains.pycharm-professional
      android-studio
      androidStudioPackages.canary
    ];
    extraGroups = [
      "adbusers"
      "kvm"
    ];
  };
}
