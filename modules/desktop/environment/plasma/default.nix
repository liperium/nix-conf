{ config
, pkgs
, lib
, ...
}:

{
  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    (catppuccin-kde.override {
      flavour = [ "macchiato" ];
      accents = [ "teal" ];
      winDecStyles = [ "classic" ];
    })
    kdePackages.merkuro
    kdePackages.kdepim-addons
    kdePackages.kio-admin
  ];
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    oxygen
  ];
}
