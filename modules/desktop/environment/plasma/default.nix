{ config, pkgs, lib, ... }:

{

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";

  # Enable automatic login for the user.
  #services.xserver.displayManager.autoLogin.enable = true;
  #services.xserver.displayManager.autoLogin.user = "liperium";

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "alt-intl";
  };

  environment.systemPackages = with pkgs;
    [
      (catppuccin-kde.override {
        flavour = [ "macchiato" ];
        accents = [ "teal" ];
        winDecStyles = [ "classic" ];
      })
    ];

}
