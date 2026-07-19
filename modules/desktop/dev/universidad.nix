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
      # Writing
      texliveFull
      tex-fmt
      onlyoffice-desktopeditors


      # cegep
      gh
    ];
    extraGroups = [
      "adbusers"
      "kvm"
    ];
  };
}
