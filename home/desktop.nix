{ config, pkgs, lib, ... }:


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

  home.packages = with pkgs; [
    #Theming
    papirus-icon-theme
    papirus-folders

    #File viewers
    vlc
    kdePackages.gwenview

    #Personnal
    brave
    thunderbird
    qalculate-qt

    (vesktop.overrideAttrs (finalAttrs: previousAttrs: {
      desktopItems = [
        ((builtins.elemAt previousAttrs.desktopItems 0).override { icon = "discord"; })
      ];
    }))
    discord

    deluge-gtk
    #bitwarden

    #Media-Streams
    obs-studio
    chatterino2

    #Creative
    gimp
    kdePackages.kate
    krita

    #Misc
    nextcloud-client

    # Office
    onlyoffice-bin
    zoom-us
  ];
  dconf.enable = true;
  catppuccin = {
    enable = true;
    accent = "mauve";
    flavor = "mocha";
    cursors = {
      enable = true;
      accent = "light";
    };

    kvantum.enable = false;
  };
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme
      ;
      name = "Papirus-Dark";
    };
  };
  qt = {
    enable = true;
    #style.name = "qtct";
    platformTheme.name = "kvantum";
  };
  xdg.configFile = {
    kvantum = {
      target = "Kvantum/kvantum.kvconfig";
      text = lib.generators.toINI { } {
        General.theme = "Catppuccin-Mocha-Mauve";
      };
    };

  };

}
