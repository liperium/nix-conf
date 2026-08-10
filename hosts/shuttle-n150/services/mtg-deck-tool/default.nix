{ inputs, ... }:
{
  imports = [ inputs.mtg-deck-tool.nixosModules.default ];

  # Caddy fronts this at mtg-deck.mattysgervais.com (Authelia-gated: the app
  # has no auth of its own). No firewall port needed, it binds loopback.
  services.mtg-deck-tool = {
    enable = true;
    address = "127.0.0.1";
    port = 8090;
    dataDir = "/zfs-data/apps/mtg-deck";
  };
}
