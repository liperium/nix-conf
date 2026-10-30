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
  services.flatpak.enable = true; #Slack

  environment.variables.TELEPORT_USER = "mgervais";
  environment.variables.TELEPORT_LOGIN = "mgervais";
  environment.variables.TELEPORT_PROXY = "tsh1.mapgears.com";

  programs.fish.interactiveShellInit = ''
    function tshssh
      set -l nodes (command tsh --proxy=tsh1.mapgears.com ls --format=names)
      or return $status

      if test (count $nodes) -gt 0
        set -l host (printf '%s\n' $nodes | ${pkgs.fzf}/bin/fzf)

        if test -n "$host"
          command tsh --proxy=tsh1.mapgears.com ssh "$host"
        end
      end
    end
  '';

  users.users.liperium = {
    packages = with pkgs; [
      # General
      unstable.arcanist
      unstable.devenv
      teleport
      (callPackage ./arc-checkout.nix { arcanist = unstable.arcanist; })

      khronos
      khronosDesktopItem
    ];
  };
}
