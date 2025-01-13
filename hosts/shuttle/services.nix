{ pkgs, lib, ... }:
{
  imports = [ ./caddy ./wireguard ];
  services.adguardhome = {
    enable = true;
    settings = null;
  };
  # Home Assistant
  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "esphome"
      "met"
      "radio_browser"
      "tplink"
      "matter"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = { };

      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [ "192.168.0.10" "127.0.0.1" ];
      };
    };
  };
  services.matter-server.enable = true; # Matter wattage plugs

  # Reverse DNS
  services.ddclient = {
    enable = true;
    configFile = "/var/lib/ddclient/ddclient.conf";
  };

  # Uptime Kuma
  services.uptime-kuma = {
    enable = true;
    settings = {
      UPTIME_KUMA_HOST = "0.0.0.0";
    };
  };
}
