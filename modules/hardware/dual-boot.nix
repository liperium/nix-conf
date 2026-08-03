{ config
, pkgs
, lib
, ...
}:
let
  rebootToWindows = pkgs.writeShellApplication {
    name = "reboot-to-windows";
    runtimeInputs = [ pkgs.systemd pkgs.jq ];
    text = ''
      entry=$(bootctl list --json=short | jq -r '.[] | select(.title? // .id? // "" | test("windows"; "i")) | .id' | head -n1)
      if [ -z "$entry" ]; then
        echo "No Windows boot entry found" >&2
        exit 1
      fi
      exec systemctl reboot --boot-loader-entry="$entry"
    '';
  };

  rebootToWindowsDesktopItem = pkgs.makeDesktopItem {
    name = "reboot-to-windows";
    desktopName = "Reboot to Windows";
    comment = "Reboot into Windows via systemd-boot";
    icon = "system-reboot";
    exec = "${lib.getExe' pkgs.polkit "pkexec"} ${lib.getExe rebootToWindows}";
    terminal = false;
    categories = [ "System" ];
  };
in
{
  # Shared dual-boot support; each host keeps its own bootloader choice/settings.
  boot.supportedFilesystems = [ "ntfs" ];

  # bootctl/systemd-boot specific, so only wire it up on hosts using systemd-boot.
  environment.systemPackages = lib.optionals config.boot.loader.systemd-boot.enable [
    rebootToWindows
    rebootToWindowsDesktopItem
  ];
}
