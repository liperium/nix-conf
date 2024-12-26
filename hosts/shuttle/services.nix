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
    };
  };
  services.matter-server.enable = true; # Matter wattage plugs

  # Reverse DNS
  services.ddclient = {
    enable = true;
    configFile = "/var/lib/ddclient/ddclient.conf";
  };
}
