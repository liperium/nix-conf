{ ... }:
{
  # UniFi Network Application (jacobalberty image, MongoDB bundled).
  # Uses host networking so L2 device discovery (SSDP/broadcast) works.
  # Caddy reverse-proxies https://unifi.mur.mattysgervais.com -> https://127.0.0.1:8443.
  systemd.tmpfiles.rules = [
    "d /var/lib/unifi 0755 root root -"
  ];
  virtualisation.oci-containers.containers.unifi = {
    image = "jacobalberty/unifi:latest";
    autoStart = true;
    environment = {
      TZ = "America/Montreal";
      RUNAS_UID0 = "false";
      UNIFI_UID = "999";
      UNIFI_GID = "999";
    };
    volumes = [
      "/var/lib/unifi:/unifi"
    ];
    extraOptions = [
      "--network=host"
      "--dns=1.1.1.1"
      "--dns=8.8.8.8"
    ];
  };
}
