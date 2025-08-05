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
      claude-code

      # Writing
      texliveFull
      tex-fmt
    ];
    extraGroups = [
      "adbusers"
      "kvm"
    ];
  };
}
