# Crash recovery and log volume control for shuttle-n150.
#
# The box freezes hard every few days (kernel wedges, nothing reaches the
# journal) and previously stayed frozen until someone hit the power button.
# It also wrote 33.6 GB of logs in five days, which killed systemd-journald
# via its own watchdog and corrupted the journal.
{ ... }:
{
  # No runtime watchdog was armed. If PID 1 stops petting the hardware
  # watchdog for 60s the board resets itself, turning a freeze into an
  # automatic reboot instead of a manual trip to the server.
  #
  # Any PID 1 stall longer than 60s becomes a hard reset, so if a heavy but
  # legitimate I/O storm ever trips this, raise it further.
  #
  # This board exposes two watchdogs (intel_oc_wdt and iTCO_wdt) and which one
  # lands on /dev/watchdog0 shifts between boots. After a reboot, confirm which
  # one systemd armed with:
  #     journalctl -b | grep -i "hardware watchdog"
  # If intel_oc_wdt turns out not to reset reliably, pin the other one with
  #     systemd.settings.Manager.WatchdogDevice = "/dev/watchdog1";
  systemd.settings.Manager = {
    RuntimeWatchdogSec = "60s";
    RebootWatchdogSec = "10min";
  };

  # Reboot 10s after a kernel panic rather than sitting at a dead console.
  boot.kernel.sysctl."kernel.panic" = 10;

  # Bound the journal. Previously unbounded, which is how journald ended up
  # writing 33.6 GB in a single 5-day boot.
  services.journald.extraConfig = ''
    SystemMaxUse=2G
    SystemMaxFileSize=128M
    MaxRetentionSec=1month
  '';

  # Jellyseerr's Jellyfin sync fails on every library item, at ~48k lines per
  # boot -- the single largest log producer on the system. This quiets the
  # routine chatter; the underlying sync failure still needs fixing in the
  # Jellyseerr UI (API key / permissions).
  systemd.services.jellyseerr.environment.LOG_LEVEL = "warn";
}
