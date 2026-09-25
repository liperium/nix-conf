{ config
, pkgs
, lib
, inputs
, ...
}:

let
  khronos = pkgs.buildGoModule {
    pname = "khronos";
    version = "unstable-2026-09-25";
    src = inputs.khronos-go;
    vendorHash = "sha256-Y5s5X3mqsJ36oX3/MhK6w9Zn13MUyeonBHtV7sVwT74=";
    subPackages = [ "cmd/khronos" ];
    env.CGO_ENABLED = "0";
    ldflags = [ "-s" "-w" ];
  };

  khronosDesktopItem = pkgs.makeDesktopItem {
    name = "khronos";
    desktopName = "Khronos";
    comment = "Mapgears timesheet tracker";
    icon = "${inputs.khronos-go}/internal/icons/idle.png";
    exec = "${khronos}/bin/khronos";
    terminal = false;
    categories = [ "Office" "Utility" ];
  };
in
{
  users.users.liperium = {
    packages = with pkgs; [
      # General
      unstable.arcanist
      unstable.devenv

      khronos
      khronosDesktopItem
    ];
  };
}
