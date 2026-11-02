{ ... }:
{
  # Google Assistant service account, referenced from HA's configuration.yaml
  # as `!include SERVICE_ACCOUNT.json`. Bind-mounted into the container below.
  # Owned by root now that the native `hass` user no longer exists.
  sops.secrets."hass-google-service-account.json" = {
    sopsFile = ../../../../modules/secrets/hass-google-service-account.json;
    format = "binary";
    path = "/var/lib/hass/SERVICE_ACCOUNT.json";
    owner = "root";
  };

  # Home Assistant (podman container).
  # Config lives in the `home-assistant` podman volume (/config). Restore your
  # backup there and re-run onboarding as needed.
  # Backend (docker) is set globally by the invoice-ninja module; inherit it.
  virtualisation.oci-containers = {
    containers.homeassistant = {
      image = "ghcr.io/home-assistant/home-assistant:stable";
      autoStart = true;
      # Note: the image is not updated on rebuilds unless the tag/version changes.
      volumes = [
        "home-assistant:/config"
        # Google Assistant service account (managed by sops), read-only.
        "/var/lib/hass/SERVICE_ACCOUNT.json:/config/SERVICE_ACCOUNT.json:ro"
      ];
      environment.TZ = "America/Montreal";
      extraOptions = [
        # Use the host network namespace so device discovery (SSDP/mDNS) works.
        "--network=host"
        # Pass USB devices (e.g. Zigbee/Z-Wave dongles) into the container.
        # A device that doesn't exist blocks startup, so uncomment/adjust only
        # if the shuttle actually has one.
        # "--device=/dev/ttyACM0:/dev/ttyACM0"
        "--device=/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0:/dev/ttyUSB0"
      ];
    };
  };
  services.matter-server.enable = true; # Matter wattage plugs
}
