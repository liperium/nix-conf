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
  environment.etc."/xdg/menus/applications.menu".text = builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  xdg.mime.enable = true;
  xdg.menus.enable = true;

  users.users.liperium.packages = with pkgs;[
    #lxqt.pcmanfm-qt
    #lxde.lxmenu-data
    shared-mime-info

    kdePackages.dolphin
    # Extract here KDE
    kdePackages.ark
    # Edit mime
    kdePackages.kde-cli-tools
    #dolphin stuff
    kdePackages.kio
    kdePackages.kdf
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.kio-admin
    kdePackages.qtwayland
    kdePackages.plasma-integration
    kdePackages.kdegraphics-thumbnailers
    kdePackages.breeze-icons
    kdePackages.qtsvg
    kdePackages.kservice
    shared-mime-info
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
