{ config
, pkgs
, lib
, ...
}:

{
  #programs.adb.enable = true;
  services.tailscale.enable = true;
  services.tailscale.extraSetFlags = [ "--operator=liperium" ];
  users.users.liperium = {
    packages = with pkgs; [
      zotero
      #teams-for-linux
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
