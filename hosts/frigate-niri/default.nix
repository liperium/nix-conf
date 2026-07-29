{ lib
, config
, pkgs
, inputs
, ...
}:
{
  time.timeZone = lib.mkForce "America/Montreal";

  imports = [
    ../frigate/hardware-configuration.nix
    ./modules.nix
  ];

  networking.hostName = "frigate";
  networking.firewall.enable = true;

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

  boot.initrd.luks.devices."luks-2a9c4cee-d3a3-41ce-9d46-f48a7cf2d703".device = "/dev/disk/by-uuid/2a9c4cee-d3a3-41ce-9d46-f48a7cf2d703";
  boot = {
    plymouth = {
      enable = true;
      theme = "bgrt";
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    loader.timeout = 0;
  };

  # FW Update
  services.fwupd.enable = true;
  # Fingerprint
  services.fprintd.enable = true;

  services.displayManager.gdm.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "liperium";
  services.displayManager.defaultSession = "niri";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services.openssh = {
    enable = true;
    ports = [ 22 ];
  };

  environment.systemPackages = with pkgs; [
    fprintd
    polkit_gnome
    nvtopPackages.intel
    bluez
    bluez-tools
    easyeffects
    omnissa-horizon-client
    unstable.cockatrice
  ];

  services.power-profiles-daemon.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  services.upower.enable = true;
  system.stateVersion = "24.11";
}
