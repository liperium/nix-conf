{ config
, pkgs
, lib
, inputs
, ...
}:

let
  # GUI password prompt for sudo -A / ssh when there is no controlling TTY.
  guiAskpass = pkgs.writeShellScriptBin "gui-askpass" ''
    exec ${lib.getExe pkgs.zenity} --password --title="''${1:-Authentication required}"
  '';
in
{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  services.displayManager.enable = true;

  hardware.graphics.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    # Electron / Chromium PipeWire capture (Discord, browsers)
    WEBRTC_USE_PIPEWIRE = "1";
    SUDO_ASKPASS = "${guiAskpass}/bin/gui-askpass";
  };

  programs.ssh.askPassword = "${guiAskpass}/bin/gui-askpass";

  environment.systemPackages = with pkgs; [
    xwayland-satellite #xwayland
    libsecret
    gnome-keyring
    polkit_gnome
    seahorse
    libnotify
    killall
    pavucontrol
    zenity
    guiAskpass
  ];
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
  security.pam.services.gdm.enableGnomeKeyring = true;

  services.gvfs.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
    config = {
      common.default = [ "gnome" ];
      niri = {
        default = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.Access" = [ "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
        "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
      };
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
