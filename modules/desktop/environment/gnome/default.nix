# Needs to have https://github.com/lilyinstarlight/nixos-cosmic upstream
{ config
, pkgs
, lib
, ...
}:
{
  services.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome-tour
    gnome-text-editor
    #cheese # webcam tool
    gnome-music
    gnome-terminal
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    #gnome-calculator
    yelp # help viewer
    gnome-maps
    gnome-weather
    gnome-contacts
    simple-scan
  ];
  environment.systemPackages = with pkgs.gnomeExtensions;
    [
      #pop-shell
      dragntile
      tiling-shell
      clipboard-history
      appindicator
    ];
}
