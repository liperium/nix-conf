{ pkgs, config, lib, ... }:
let
  homerConfig = pkgs.writeText "config.yml" ''
    title: "Dashboard"
    subtitle: "mattysgervais.com"
    logo: "logo.png"

    header: true
    footer: '<p>mattysgervais.com</p>'

    theme: default
    defaults:
      colorTheme: dark
    links:
      - name: "GitHub"
        icon: "fab fa-github"
        url: "https://github.com"
        target: "_blank"

    services:
      - name: "Public"
        icon: "fas fa-globe"
        items:

          - name: "Jellyfin"
            logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/jellyfin.png"
            subtitle: "Media server"
            tag: "media"
            url: "https://jellyfin.mattysgervais.com"
            target: "_blank"
            
          - name: "Nextcloud"
            logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/nextcloud.png"
            subtitle: "Cloud storage"
            tag: "storage"
            url: "https://nextcloud.mattysgervais.com"
            target: "_blank"

          - name: "ConvertX"
            logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/convertx.png"
            subtitle: "File converter"
            tag: "tools"
            url: "https://convertx.mattysgervais.com"
            target: "_blank"

          - name: "PDF Tools"
            logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/stirling-pdf.png"
            subtitle: "PDF utilities"
            tag: "tools"
            url: "https://pdf.mattysgervais.com"
            target: "_blank"

          - name: "Immich"
            logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/immich.png"
            subtitle: "Photos"
            tag: "media"
            url: "https://immich.mattysgervais.com"
            target: "_blank"

          - name: "Fusion"
            logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/linkace.png"
            subtitle: "Self-Hosted Construct3"
            tag: "app"
            url: "https://fusion.mattysgervais.com"
            target: "_blank"
          
          - name: "MTG Scraper"
            logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/magic-the-gathering.png"
            subtitle: "Card prices"
            tag: "app"
            url: "https://mtg.mattysgervais.com"
            target: "_blank"

          - name: "Authelia"
            logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/authelia.png"
            subtitle: "Authentication"
            tag: "auth"
            url: "https://auth.mattysgervais.com"
            target: "_blank"

      - name: "Media"
        icon: "fas fa-video"
        items:
          - name: "Jellyseerr"
            logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/jellyseerr.png"
            subtitle: "Requests"
            tag: "media"
            url: "https://jellyseerr.mur.mattysgervais.com"
            target: "_blank"

          - name: "Sonarr"
            logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/sonarr.png"
            subtitle: "TV Shows"
            tag: "arr"
            url: "https://sonarr.mur.mattysgervais.com"
            target: "_blank"

          - name: "Radarr"
            logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/radarr.png"
            subtitle: "Movies"
            tag: "arr"
            url: "https://radarr.mur.mattysgervais.com"
            target: "_blank"

          - name: "Lidarr"
            logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/lidarr.png"
            subtitle: "Music"
            tag: "arr"
            url: "https://lidarr.mur.mattysgervais.com"
            target: "_blank"

          - name: "Prowlarr"
            logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/prowlarr.png"
            subtitle: "Indexers"
            tag: "arr"
            url: "https://prowlarr.mur.mattysgervais.com"
            target: "_blank"

          - name: "Bazarr"
            logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/bazarr.png"
            subtitle: "Subtitles"
            tag: "arr"
            url: "https://bazarr.mur.mattysgervais.com"
            target: "_blank"

          - name: "qBittorrent"
            logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/qbittorrent.png"
            subtitle: "Torrents"
            tag: "download"
            url: "https://qbittorrent.mur.mattysgervais.com"
            target: "_blank"

      - name: "System"
        icon: "fas fa-server"
        items:
          - name: "AdGuard"
            logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/adguard-home.png"
            subtitle: "DNS"
            tag: "network"
            url: "https://adguard.mur.mattysgervais.com"
            target: "_blank"

          - name: "Dockge"
            logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/dockge.png"
            subtitle: "Docker"
            tag: "system"
            url: "https://udockge.mur.mattysgervais.com"
            target: "_blank"

          - name: "Uptime Kuma"
            logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/uptime-kuma.png"
            subtitle: "Monitoring"
            tag: "system"
            url: "https://kuma.mur.mattysgervais.com"
            target: "_blank"

          - name: "Home Assistant"
            logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/home-assistant.png"
            subtitle: "Home automation"
            tag: "automation"
            url: "http://hass.mur.mattysgervais.com"
            target: "_blank"

  '';
in
{
  # Create symlinks for Caddy to serve homer
  systemd.tmpfiles.rules = [
    "L+ /var/lib/homer - - - - ${pkgs.homer}"
    "L+ /var/lib/homer-config.yml - - - - ${homerConfig}"
  ];
}
