{ pkgs, lib, ... }:
{
  systemd.services.pufferpanel = {
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      PrivateUsers = lib.mkForce false;
      User = "pufferpanel";
      Group = "pufferpanel";
    };
  };

  users.users.pufferpanel = {
    isSystemUser = true;
    group = "pufferpanel";
    home = "/var/lib/pufferpanel";
    createHome = true;
  };

  users.groups.pufferpanel = { };
  services.pufferpanel = {
    enable = true;
    extraPackages = with pkgs; [ bash curl gawk gnutar gzip depotdownloader jdk21 ];
    package = pkgs.buildFHSEnv {
      name = "pufferpanel-fhs";
      runScript = lib.getExe pkgs.pufferpanel;
      targetPkgs = pkgs': with pkgs'; [
        icu
        openssl
        zlib
        # Valheim
        libpulseaudio
        gccNGPackages_15.libatomic
        steamcmd
        glibc
        libgcc
        SDL2
        libGL
        libx11
        libxcursor
        libxrandr
        libxi
        libxext
        libxkbcommon
        dotnet-runtime
      ];
    };
    environment = {
      PUFFER_WEB_HOST = ":2556";
      PUFFER_PANEL_REGISTRATIONENABLED = "false";
    };
  };
}
