{ config
, pkgs
, lib
, ...
}:

{
  # Enable the X11 windowing system - Configure keymap in X11
  services.xserver.enable = true;

  # Enable Hyprland - Need it here + home-manager
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  hardware.graphics.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Ozone/discord/wayland

  environment.systemPackages = with pkgs; [
    libsecret
    gnome-keyring
    polkit_gnome
    seahorse
    libnotify # Required by apps to send notifications
    killall # Restart processes
    pavucontrol
    hyprpolkitagent
  ];

  users.users.liperium.packages = with pkgs;[
    #lxqt.pcmanfm-qt
    #lxde.lxmenu-data
    shared-mime-info

    kdePackages.dolphin
    # Extract here KDE
    kdePackages.ark
    kdePackages.qtsvg # See svg icons
    kdePackages.kio-fuse # mount drives
    kdePackages.kio-extras
  ];

  security.polkit.enable = true;

  # Enable a keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  services.gvfs.enable = true; # Mount, trash, and other functionalities

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };
  # Portal to make it easy
  # xdg.portal = {
  #   enable = true;
  #   config = {
  #     common.default = "lxqt";
  #     pantheon.default = "lxqt";
  #     gtk.default = "lxqt";
  #     hyprland = {
  #       default = [
  #         "hyprland"
  #         "lxqt"
  #       ];
  #     };
  #   };
  #   configPackages = with pkgs; [
  #     xdg-desktop-portal-hyprland
  #     lxqt.xdg-desktop-portal-lxqt
  #   ];
  #   extraPortals = with pkgs; [
  #     #xdg-desktop-portal-gtk
  #     #kdePackages.xdg-desktop-portal-kde
  #     lxqt.xdg-desktop-portal-lxqt
  #     xdg-desktop-portal-hyprland
  #   ];
  # };

  # Sound stuff
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
