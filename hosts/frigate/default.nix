{ lib
, config
, pkgs
, inputs
, ...
}:
{
  time.timeZone = lib.mkForce "America/Montreal";

  imports = [
    ./hardware-configuration.nix
    ./modules.nix
  ];

  networking.hostName = "frigate";
  networking.firewall.enable = false;

  # Notify desktop user when Wi-Fi requires captive-portal sign-in.
  networking.networkmanager.dispatcherScripts = [
    {
      type = "basic";
      source = pkgs.writeShellScript "captive-portal-notify" ''
        #!/usr/bin/env bash
        set -euo pipefail

        [ "''${2:-}" = "connectivity-change" ] || exit 0

        status=$(${pkgs.networkmanager}/bin/nmcli networking connectivity)
        [ "$status" = "portal" ] || exit 0

        user="liperium"
        uid=$(id -u "$user")

        ${pkgs.systemd}/bin/systemd-run --quiet --collect --uid="$uid" \
          --setenv="DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus" \
          --setenv="XDG_RUNTIME_DIR=/run/user/$uid" \
          -- ${pkgs.bash}/bin/bash -c '
            action=$(${pkgs.libnotify}/bin/notify-send -u critical -a "Network" \
              -A open="Open neverssl.com" \
              "Wi-Fi sign-in required" "This network needs you to log in in a browser.")
            [ "$action" = "open" ] && ${pkgs.xdg-utils}/bin/xdg-open http://neverssl.com
          '
      '';
    }
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;

  boot.initrd.luks.devices."luks-2a9c4cee-d3a3-41ce-9d46-f48a7cf2d703".device = "/dev/disk/by-uuid/2a9c4cee-d3a3-41ce-9d46-f48a7cf2d703";

  # FW Update
  services.fwupd.enable = true;
  # Fingerprint
  services.fprintd.enable = true;
  # Fingerprint reader under GDM: https://wiki.archlinux.org/title/Fprint
  # adm: was in base as "system76 stuff?", kept here pending a reason to drop it.
  users.users.liperium.extraGroups = [ "input" "adm" ];

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "liperium";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  environment.systemPackages = with pkgs; [
    fprintd
    polkit_gnome
    nvtopPackages.intel
    bluez
    bluez-tools
    easyeffects
    #omnissa-horizon-client
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="1", RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced"
    SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="0", RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver"
  '';
  system.stateVersion = "24.11";
}
