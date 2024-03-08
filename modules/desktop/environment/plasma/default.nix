{ config, pkgs, lib, ... }:

{

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable the KDE Plasma Desktop Environment.
  #services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  #services.xserver.displayManager.defaultSession = "plasmawayland";

  # Enable automatic login for the user.
  #services.xserver.displayManager.autoLogin.enable = true;
  #services.xserver.displayManager.autoLogin.user = "liperium";

  environment.systemPackages = with pkgs;
    [
      xwaylandvideobridge
      #gnome.seahorse
      (catppuccin-kde.override {
        flavour = [ "macchiato" ];
        accents = [ "teal" ];
        winDecStyles = [ "classic" ];
      })
    ];
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    oxygen
  ];
  #programs.ssh.askPassword = "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass"; # Hyprland with seahorse, thus try to make kde use seahorse instead of ksshaskpass

}
