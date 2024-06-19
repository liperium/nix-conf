{ config, pkgs, ... }:


{
  imports = [
    ./hypr-conf
    ./kitty
    ./tmux
    ./zsh
    ./helix
    ./zellij
  ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  home.username = "liperium";
  home.homeDirectory = "/home/liperium";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    fastfetch
    dconf
    # needed for ark archives
    p7zip
    rar
    # From default config modules 
    #Basic Needs
    wl-clipboard
    firefox
    steam-run
    gparted
    vlc
    widevine-cdm
    libsForQt5.kalk

    #Theming
    papirus-icon-theme

    #Personnal
    logseq # qownnotes replacement, rip.
    betterdiscordctl
    discord
    vesktop

    qbittorrent
    bitwarden

    #Media-Streams
    obs-studio
    chatterino2
    streamlink
    streamlink-twitch-gui-bin

    #Creative
    gimp
    kate
    krita
    kdePackages.kdenlive

    #Misc
    spot
    nextcloud-client # ? cmd
    feishin

    # Office
    onlyoffice-bin
    zoom-us

    #Theming
    (catppuccin-kvantum.override {
      accent = "Mauve";
      variant = "Mocha";
    })
    qt6Packages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
  ];
  #Direnv
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
  home.sessionVariables = {
    # EDITOR = "emacs";
  };
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "org.kde.dolphin.desktop" ];
      #"inode/directory" = ["gnome.nautilus.desktop"];
      "application/pdf" = [ "firefox.desktop" ];

      "application/gzip" = [ "org.kde.ark.desktop" ];
      "application/zip" = [ "org.kde.ark.desktop" ];
      "application/x-7z-compressed" = [ "org.kde.ark.desktop" ];
      "application/x-compressed-tar" = [ "org.kde.ark.desktop" ];

      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];

      "x-scheme-handler/x-github-client" = [ "github-desktop.desktop" ];
      "x-scheme-handler/x-github-desktop-auth" = [ "github-desktop.desktop" ];
    };
    associations.added = {
      "text/plain" = [ "Helix.desktop" ];
      "image/png" = [ "org.kde.gwenview.desktop" ];
      "image/jpeg" = [ "org.kde.gwenview.desktop" ];
    };
  };

  xdg.desktopEntries = {
    firefox-fusion = {
      name = "Firefox FJ";
      genericName = "Web Browser Fusion";
      exec = "firefox %U -p fusion";
      terminal = false;
      categories = [
        "Application"
        "Network"
        "WebBrowser"
      ];
      mimeType = [
        "text/html"
        "text/xml"
      ];
    };
    android-studio-env = {
      name = "Android Studio Patched Envs";
      genericName = "Coding For Android";
      exec = "env -u QT_QPA_PLATFORM android-studio %U";
      terminal = false;
    };
    android-studio-canary-env = {
      name = "Android Studio Canary with Patched Envs";
      genericName = "Coding For Android, Canary version";
      exec = "env -u QT_QPA_PLATFORM android-studio-canary %U";
      terminal = false;
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
      "org/gnome/nautilus/preferences" = {
        always-use-location-entry = true; # shows dir in nautilus
      };
    };
  };
  home.pointerCursor = {
    package = pkgs.kdePackages.breeze-gtk;
    name = "breeze_cursors";
    size = 24;
  };

  qt = {
    enable = true;
    # disabled cause crashes KDE I think?
    #platformTheme.name = "qtct";
    #style.name = "kvantum";
  };

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.kdePackages.breeze-gtk;
      name = "breeze_cursors";
      size = 24;
    };
    theme = {
      name = "Catppuccin-Mocha-Standard-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        variant = "mocha"; # Since gtk are applications, I like Mocha for apps and Macchiato for OS
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Noto Sans";
      package = pkgs.noto-fonts;
      size = 12;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
