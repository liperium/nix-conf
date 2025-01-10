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
  };

  hardware.graphics.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Ozone/discord/wayland

  environment.systemPackages = with pkgs; [
    libsecret
    gnome-keyring
    polkit_gnome
    seahorse
    kdePackages.polkit-qt-1
    kdePackages.polkit-kde-agent-1
    # kdePackages.kwallet
    # kdePackages.kwallet-pam

    #waybar # Top status bar # Ho~me
    #wlogout # Home
    #networkmanagerapplet

    libnotify # Required by apps to send notifications

    #pulseaudio
    killall # Restart processes
    #pavucontrol # Audio panel
  ];
  users.users.liperium.packages = with pkgs;[
    lxqt.pcmanfm-qt
    lxde.lxmenu-data
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

  # Portal to make it easy
  xdg.portal = {
    enable = true;
    config = {
      hyprland = {
        default = [
          "hyprland"
          "kde"
        ];
      };
    };
    configPackages = with pkgs; [
      xdg-desktop-portal-hyprland
      kdePackages.xdg-desktop-portal-kde
    ];
    extraPortals = with pkgs; [
      #xdg-desktop-portal-gtk
      kdePackages.xdg-desktop-portal-kde
      #xdg-desktop-portal-hyprland
    ];
  };

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
