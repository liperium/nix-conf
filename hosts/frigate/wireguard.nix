{ config, pkgs, ... }:
let
  wgBootstrap = pkgs.writeShellApplication {
    name = "wg-bootstrap";
    runtimeInputs = with pkgs; [ networkmanager wireguard-tools tailscale iputils ];
    text = ''
      SCHOOL_WIFI="Cegep-Public"
      HOTSPOT="Mattys's P7"
      WG_SERVICE="wg-quick-wg0.service"
      WG_INTERFACE="wg0"
      HANDSHAKE_TIMEOUT=15
      SWITCH_DELAY=3
      SCAN_TIMEOUT=60

      log() { echo "[$(date '+%H:%M:%S')] $1"; }

      if [[ $EUID -ne 0 ]]; then
        echo "Re-running with sudo..."
        exec sudo "$0" "$@"
      fi

      log "Turn on your phone hotspot now. (toggle wifi off/on in quickshell if needed)"
      echo "   Press Enter once it's on..."
      read -r

      log "Scanning for '$HOTSPOT'..."
      FOUND=0
      for i in $(seq 1 "$SCAN_TIMEOUT"); do
        nmcli device wifi rescan 2>/dev/null || true
        sleep 1
        if nmcli -t -f SSID device wifi list 2>/dev/null | grep -qF "$HOTSPOT"; then
          log "'$HOTSPOT' visible after ''${i}s."
          FOUND=1
          break
        fi
        if (( i % 5 == 0 )); then
          log "Still scanning... (''${i}s) — try toggling wifi if stuck"
        fi
      done

      if [[ "$FOUND" -eq 0 ]]; then
        log "'$HOTSPOT' not found after ''${SCAN_TIMEOUT}s. Aborting."
        exit 1
      fi

      log "Connecting to '$HOTSPOT'..."
      if nmcli device wifi connect "$HOTSPOT"; then
        log "Connected to hotspot."
      else
        log "Failed to connect to '$HOTSPOT'. Is it visible?"
        exit 1
      fi

      log "Starting WireGuard..."
      systemctl start "$WG_SERVICE"
      sleep 1

      log "Waiting for WireGuard handshake..."
      for i in $(seq 1 "$HANDSHAKE_TIMEOUT"); do
        HANDSHAKE=$(wg show "$WG_INTERFACE" latest-handshakes | awk '{print $2}')
        if [[ -n "$HANDSHAKE" && "$HANDSHAKE" != "0" ]]; then
          log "Handshake established!"
          break
        fi
        if [[ "$i" -eq "$HANDSHAKE_TIMEOUT" ]]; then
          log "No handshake after ''${HANDSHAKE_TIMEOUT}s. Aborting."
          systemctl stop "$WG_SERVICE"
          exit 1
        fi
        sleep 1
      done

      log "Verifying tunnel connectivity..."
      if ping -c 1 -W 3 192.168.1.10 &>/dev/null; then
        log "Tunnel is passing traffic."
      else
        log "Handshake OK but no traffic. Continuing anyway..."
      fi

      if tailscale up &>/dev/null; then
        log "Tailscale Up."
      else
        log "Tailscale not working. Continuing anyway..."
      fi

      log "Switching back to '$SCHOOL_WIFI'..."
      sleep "$SWITCH_DELAY"
      if nmcli device wifi connect "$SCHOOL_WIFI"; then
        log "Connected to school wifi."
      else
        log "Failed to reconnect to school wifi."
        exit 1
      fi

      sleep 2
      if ping -c 2 -W 3 192.168.1.10 &>/dev/null; then
        log "WireGuard is working over school wifi. You're good!"
      else
        log "Tunnel may have dropped. Check 'sudo wg show'."
      fi

      log "You can turn off your phone hotspot now."
    '';
  };

  wgTeardown = pkgs.writeShellApplication {
    name = "wg-teardown";
    runtimeInputs = with pkgs; [ tailscale ];
    text = ''
      WG_SERVICE="wg-quick-wg0.service"

      log() { echo "[$(date '+%H:%M:%S')] $1"; }

      if [[ $EUID -ne 0 ]]; then
        echo "Re-running with sudo..."
        exec sudo "$0" "$@"
      fi

      log "Bringing Tailscale down..."
      if tailscale down &>/dev/null; then
        log "Tailscale down."
      else
        log "Tailscale down failed or already down."
      fi

      log "Stopping WireGuard..."
      if systemctl stop "$WG_SERVICE"; then
        log "WireGuard stopped."
      else
        log "WireGuard stop failed or already stopped."
      fi

      log "Done. Hotspot no longer needed."
    '';
  };
in
{
  sops.secrets.frig-wg-priv = { };

  networking.wg-quick.interfaces.wg0 = {
    autostart = false;
    address = [ "10.100.0.3/24" ];
    dns = [ "192.168.1.15" ];
    privateKeyFile = config.sops.secrets.frig-wg-priv.path;

    peers = [
      {
        publicKey = "R9rxBPbIhcPyBMeFfe+dH86cdYMnZIWqThp6piR4z2A=";
        allowedIPs = [ "192.168.0.0/24" ];
        endpoint = "vpn.mattysgervais.com:51820";
        persistentKeepalive = 25;
      }
    ];
  };

  environment.systemPackages = [ wgBootstrap wgTeardown ];
}
