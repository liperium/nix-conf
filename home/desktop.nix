{ config, pkgs, ... }:


{
  imports = [
    # Everywhere
    ./console.nix

    # Desktop
    ./kitty
    ./firefox
  ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = "liperium";
  home.homeDirectory = "/home/liperium";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.sessionVariables = {
    COSMIC_DISABLE_DIRECT_SCANOUT = "true";
  };

  home.packages = with pkgs; [
    #Theming
    papirus-icon-theme

    #File viewers
    vlc
    dolphin

    #Personnal
    logseq # qownnotes replacement, rip.
    #discord

    #vesktop
    (vesktop.overrideAttrs (finalAttrs: previousAttrs: {
      desktopItems = [
        ((builtins.elemAt previousAttrs.desktopItems 0).override { icon = "discord"; })
      ];
    }))

    qbittorrent
    #bitwarden

    #Media-Streams
    obs-studio
    chatterino2

    #Creative
    gimp
    kate
    krita
    kdePackages.kdenlive

    #Misc
    nextcloud-client
    feishin

    # Office
    onlyoffice-bin
    zoom-us
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      #"inode/directory" = [ "org.kde.dolphin.desktop" ];
      "inode/directory" = ["gnome.nautilus.desktop"];
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


  # xdg.desktopEntries = {
  #   android-studio-env = {
  #     name = "Android Studio Patched Envs";
  #     genericName = "Coding For Android";
  #     exec = "env -u QT_QPA_PLATFORM android-studio %U";
  #     terminal = false;
  #   };
  #   android-studio-canary-env = {
  #     name = "Android Studio Canary with Patched Envs";
  #     genericName = "Coding For Android, Canary version";
  #     exec = "env -u QT_QPA_PLATFORM android-studio-canary %U";
  #     terminal = false;
  #   };
  # };


  dconf = {
    enable = true; # needed for theming
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };

  catppuccin = {
    enable = true;
    accent = "mauve";
    flavor = "mocha";
    pointerCursor = {
      enable = true;
      accent = "light";
    };
  };
  gtk = {
    enable = true;

    catppuccin = {
      enable = true;
      gnomeShellTheme = true;
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";
      catppuccin.enable = true;
    };
  };
}
