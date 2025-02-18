{ config, pkgs, ... }:

let
  updateScript = pkgs.writeShellScriptBin "update-system" ''
    #!/bin/sh
    cd /home/liperium/nix-conf
    ${pkgs.su}/bin/su -c "git pull" liperium && ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake /home/liperium/nix-conf'';
in
{
  systemd.services.nixos-update = {
    description = "NixOS System Update";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${updateScript}/bin/update-system";
    };
  };

  systemd.timers.nixos-update = {
    description = "Run NixOS System Update every Monday at 3 AM";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Mon 03:00";
      Persistent = true;
    };
  };
}

