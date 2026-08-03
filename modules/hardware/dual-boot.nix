{ config
, pkgs
, lib
, ...
}:
let
  rebootToWindows = pkgs.writeShellApplication {
    name = "reboot-to-windows";
    runtimeInputs = [ pkgs.systemd pkgs.jq pkgs.efibootmgr ];
    text = ''
    '' + lib.optionalString config.boot.loader.systemd-boot.enable ''
      # Case 1: Windows lives on the same ESP as systemd-boot, so bootctl
      # auto-discovers it as a loader entry. Only valid under systemd-boot:
      # --boot-loader-entry sets an EFI variable no other bootloader reads.
      entry=$(bootctl list --json=short | jq -r '.[] | select(.title? // .id? // "" | test("windows"; "i")) | .id' | head -n1)
      if [ -n "$entry" ]; then
        exec systemctl reboot --boot-loader-entry="$entry"
      fi
    '' + ''

      # Case 2: Windows is on its own ESP (separate disk). bootctl can't see it,
      # but the firmware keeps a "Windows Boot Manager" NVRAM entry we can chain
      # to via BootNext. Booting Windows through its native path also keeps
      # BitLocker's measured-boot state happy.
      #
      # Match on the device path, not the title: leftovers from other bootloaders
      # can also be titled "Windows Boot Manager" while actually pointing at e.g.
      # grubx64.efi, and picking one of those silently boots the wrong thing.
      # `|| true`: under `set -euo pipefail` a no-match grep (or head closing the
      # pipe early) would abort here, before the message below ever prints.
      bootnum=$(efibootmgr -v \
        | grep -iE '^Boot[0-9A-Fa-f]{4}\*' \
        | grep -i 'bootmgfw\.efi' \
        | head -n1 \
        | sed 's/^Boot\([0-9A-Fa-f]\{4\}\).*/\1/') || true
      if [ -z "$bootnum" ]; then
        echo "No Windows boot entry found in UEFI NVRAM" >&2
        exit 1
      fi
      efibootmgr --bootnext "$bootnum" >/dev/null
      exec systemctl reboot
    '';
  };

  rebootToWindowsDesktopItem = pkgs.makeDesktopItem {
    name = "reboot-to-windows";
    desktopName = "Reboot to Windows";
    comment = "Reboot into Windows";
    icon = "system-reboot";
    # The store's pkexec cannot be setuid (Nix store bans setuid bits) and exits
    # with "pkexec must be setuid root". The real one is the security.wrappers copy.
    exec = "/run/wrappers/bin/pkexec ${lib.getExe rebootToWindows}";
    terminal = false;
    categories = [ "System" ];
  };
in
{
  # Shared dual-boot support; each host keeps its own bootloader choice/settings.
  boot.supportedFilesystems = [ "ntfs" ];

  # Needs an EFI bootloader we know how to hand off from, so only wire it up
  # on hosts using systemd-boot or limine.
  environment.systemPackages =
    lib.optionals (config.boot.loader.systemd-boot.enable || config.boot.loader.limine.enable) [
      rebootToWindows
      rebootToWindowsDesktopItem
    ];
}
