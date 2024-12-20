{ pkgs, lib, ... }:
{
  imports = [ ./caddy ];
  services.adguardhome = {
    enable = true;
    settings = null;
    # settings = {
    #   dns = {
    #     upstream_dns = [
    #       # Example config with quad9
    #       "9.9.9.9#dns.quad9.net"
    #       "149.112.112.112#dns.quad9.net"
    #       # Uncomment the following to use a local DNS service (e.g. Unbound)
    #       # Additionally replace the address & port as needed
    #       # "127.0.0.1:5335"
    #     ];
    #   };
    #   filtering = {
    #     protection_enabled = true;
    #     filtering_enabled = true;

    #     parental_enabled = false; # Parental control-based DNS requests filtering.
    #     safe_search = {
    #       enabled = false; # Enforcing "Safe search" option for search engines, when possible.
    #     };
    #     # rewrites = map ({ domain, answer }: { domain = domain; answer = answer; }) [
    #     #   {
    #     #     domain = "mur.mattysgervais.com";
    #     #     answer = "192.168.0.10";
    #     #   }
    #     # ];
    #     # The following notation uses map
    #     # to not have to manually create {enabled = true; url = "";} for every filter
    #     # This is, however, fully optional
    #     filters = map (url: { enabled = true; url = url; }) [
    #       "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
    #       "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious url blocklist
    #       "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt" # HaGeZi's Pro DNS Blocklist
    #     ];

    #   };
    #};
  };
  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "esphome"
      "met"
      "radio_browser"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = { };
    };
  };
}
