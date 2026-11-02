{ ... }:
{
  # One folder per service; each declares everything it needs.
  imports = [
    ./caddy
    ./wireguard
    ./nextcloud
    ./jellyfin
    ./vpn-namespace
    ./qbittorrent
    ./nzbget
    ./homer
    ./mtg-scraper
    ./mtg-deck-tool
    ./authelia
    ./ml-production-website
    ./countdown
    ./construct3-hoster
    ./invoice-ninja
    ./adguardhome
    ./unifi
    ./home-assistant
    ./ddclient
    ./uptime-kuma
    ./arr
    ./immich
    ./samba
    ./stirling-pdf
    ./convertx
    ./pufferpanel
    ./stash
  ];
}
