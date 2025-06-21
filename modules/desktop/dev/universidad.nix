{ config
, pkgs
, lib
, ...
}:

{
  programs.adb.enable = true;
  users.users.liperium = {
    packages = with pkgs; [
      #jetbrains.datagrip
      #androidStudioPackages.canary
      zotero
      brev-cli
      teams-for-linux
    ];
    extraGroups = [
      "adbusers"
      "kvm"
    ];
  };
}
