{pkgs,config,lib,...}:
{
	services.homer = {
	  enable = true;
	  virtualHost.caddy.enable=true;
	  virtualHost.domain = "homepage.mur.mattysgervais.com";
	  settings = ''{
      title: "Dashboard"
      subtitle: "mattysgervais.com"
      logo: "logo.png"

      header: true
      footer: '<p>mattysgervais.com</p>'

      theme: default
      colors:
        light: # Catppuccin Latte
          highlight-primary: "#1e66f5"     # Blue
          highlight-secondary: "#ea76cb"   # Pink
          highlight-hover: "#7287fd"       # Lavender
          background: "#eff1f5"            # Base
          card-background: "#e6e9ef"       # Mantle
          text: "#4c4f69"                  # Text
          text-header: "#eff1f5"           # Base
          text-title: "#4c4f69"            # Text
          text-subtitle: "#5c5f77"         # Subtext1
          card-shadow: rgba(220, 224, 232, 0.5)
          link: "#1e66f5"                  # Blue
          link-hover: "#04a5e5"            # Sky
        dark: # Catppuccin Mocha
          highlight-primary: "#89b4fa"     # Blue
          highlight-secondary: "#f5c2e7"   # Pink
          highlight-hover: "#b4befe"       # Lavender
          background: "#1e1e2e"            # Base
          card-background: "#181825"       # Mantle
          text: "#cdd6f4"                  # Text
          text-header: "#cdd6f4"           # Text
          text-title: "#cdd6f4"            # Text
          text-subtitle: "#a6adc8"         # Subtext1
          card-shadow: rgba(17, 17, 27, 0.7)
          link: "#89b4fa"                  # Blue
          link-hover: "#89dceb"            # Sky

      links:
        - name: "GitHub"
          icon: "fab fa-github"
          url: "https://github.com"
          target: "_blank"

      services:
        - name: "Public"
          icon: "fas fa-globe"
          items:
            - name: "Nextcloud"
              logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/nextcloud.png"
              subtitle: "Cloud storage"
              tag: "storage"
              url: "https://nextcloud.mattysgervais.com"
              target: "_blank"
        
            - name: "Immich"
              logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/immich.png"
              subtitle: "Photos"
              tag: "media"
              url: "https://immich.mattysgervais.com"
              target: "_blank"
        
            - name: "Jellyfin"
              logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/jellyfin.png"
              subtitle: "Media server"
              tag: "media"
              url: "https://jellyfin.mattysgervais.com"
              target: "_blank"
        
            - name: "Fusion"
              subtitle: "Fusion"
              tag: "app"
              url: "https://fusion.mattysgervais.com"
              target: "_blank"
        
            - name: "ConvertX"
              subtitle: "Converter"
              tag: "tools"
              url: "https://convertx.mattysgervais.com"
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
        
            - name: "PDF Tools"
              logo: "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/stirling-pdf.png"
              subtitle: "PDF utilities"
              tag: "tools"
              url: "https://pdf.mur.mattysgervais.com"
              target: "_blank"
	    
	  }'';
	};
}
