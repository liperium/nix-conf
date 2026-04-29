{ config
, pkgs
, lib
, inputs
, ...
}:

{
  nixpkgs.overlays = [ inputs.dolphin-overlay.overlays.default ];

  programs.niri = {
    enable = true;
    package = pkgs.unstable.niri;
  };

  services.displayManager.enable = true;

  hardware.graphics.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    xwayland-satellite #xwayland
    libsecret
    gnome-keyring
    polkit_gnome
    seahorse
    libnotify
    killall
    pavucontrol
    hyprpolkitagent
  ];
  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
    "org.freedesktop.impl.portal.ScreenCast" = [ "niri" ];
    "org.freedesktop.impl.portal.Screenshot" = [ "niri" ];
    "org.freedesktop.impl.portal.RemoteDesktop" = [ "niri" ];
    default = [ "gnome" ];
  };

  xdg.mime.enable = true;
  xdg.menus.enable = true;
  environment.etc."/xdg/menus/applications.menu".text = builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  users.users.liperium.packages = with pkgs; [
    shared-mime-info
    kdePackages.dolphin
    kdePackages.ark
    kdePackages.ffmpegthumbs
    icoutils
    kdePackages.kdegraphics-thumbnailers
    resvg
    kdePackages.kimageformats
    kdePackages.kde-cli-tools
    kdePackages.kio
    kdePackages.kdf
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.kio-admin
    kdePackages.qtwayland
    kdePackages.plasma-integration
    kdePackages.breeze-icons
    kdePackages.qtsvg
    kdePackages.kservice
  ];

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  services.gvfs.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config = {
      common.default = [ "gnome" ];
    };
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
