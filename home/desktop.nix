{ config, pkgs, lib, ... }:


{
  imports = [
    # Everywhere
    ./console.nix

    # Desktop
    #./kitty
    ./firefox
  ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = "liperium";
  home.homeDirectory = "/home/liperium";

  home.stateVersion = "23.11"; # Please read the comment before changing.
  home.enableNixpkgsReleaseCheck = false;

  home.packages = with pkgs; [
    #File viewers
    vlc
    kdePackages.gwenview

    #Personnal
    brave
    thunderbird
    qalculate-qt
    #unstable.discord
    discord
    deluge-gtk

    #Creative
    gimp

    # krita

    #Misc
    nextcloud-client

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
    defaultApplications = {
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
      "application/xhtml+xml" = "zen.desktop";
    };
  };

  dconf.enable = true;
  catppuccin = {
    enable = true;
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
  services.xembed-sni-proxy.enable = true;

}
