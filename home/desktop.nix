{ config, inputs, pkgs, lib, ... }:

{
  imports = [
    # Everywhere
    ./console.nix

    # Desktop
    #./kitty
    #./firefox
  ];
  home.enableNixpkgsReleaseCheck = false;

  home.packages = with pkgs; [
    #File viewers
    vlc
    kdePackages.gwenview

    #Personnal
    brave
    qalculate-qt
    unstable.discord
    unstable.codex
    #discord
    deluge-gtk
    #joplin
    unstable.joplin-desktop

    #Creative
    gimp

    # krita

    #Misc
    nextcloud-client
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

  ];

  # programs.obs-studio = {
  #   enable = true;
  #   plugins = with pkgs.obs-studio-plugins; [
  #     obs-tuna
  #     obs-backgroundremoval
  #     obs-vaapi
  #   ];
  # };

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = "zen.desktop";
    };
    defaultApplications = {
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
      "application/xhtml+xml" = "zen.desktop";
      "application/pdf" = "zen.desktop";
    };
  };

  dconf.enable = true;
  catppuccin = {
    enable = true;
    autoEnable = true;
    accent = "mauve";
    flavor = "mocha";
    cursors = {
      enable = true;
      accent = "light";
    };

    #gtk.enable = true;
    kvantum.enable = true;
    qt5ct.enable = true;
  };
  gtk = {
    enable = true;
    gtk4.theme = null;
  };
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };
  # QT_STYLE_OVERRIDE=kvantum makes the KDE portal's QML dialogs (e.g. Dolphin's
  # "Open With > Other Application") look for a "kvantum" QtQuick style, which
  # doesn't exist, so the dialog fails to load and nothing shows.
  xdg.configFile."systemd/user/plasma-xdg-desktop-portal-kde.service.d/qml-style.conf".text = ''
    [Service]
    UnsetEnvironment=QT_STYLE_OVERRIDE
  '';
  services.xembed-sni-proxy.enable = true;
  systemd.user.services.xembed-sni-proxy.Service = {
    Environment = [ "DISPLAY=:0" ];
    Restart = lib.mkForce "on-failure";
    RestartSec = 2;
  };

}
