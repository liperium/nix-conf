{ inputs, ... }:
{
  imports = [
    inputs.mtg-card-scraper.nixosModules.default
  ];

  services.mtg-scraper = {
    enable = true;
    port = 8501;
    address = "0.0.0.0";
    openFirewall = false; # firewall is disabled on shuttle-n150
  };
}
