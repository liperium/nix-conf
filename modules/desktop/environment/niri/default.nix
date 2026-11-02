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
  # Only the kded module Dolphin needs for unlock prompts (e.g. BitLocker);
  # the rest of plasma-workspace's kded modules would fight noctalia (tray, notifications).
  solidUiServer = pkgs.runCommand "soliduiserver" { } ''
    mkdir -p $out/lib/qt-6/plugins/kf6/kded
    ln -s ${pkgs.kdePackages.plasma-workspace}/lib/qt-6/plugins/kf6/kded/soliduiserver.so $out/lib/qt-6/plugins/kf6/kded/
  '';
in
{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  # KF6 apps get no palette out of the qt6ct platform theme: they end up with
  # Qt's default *light* palette while Kvantum paints the widgets dark, so item
  # text and the monochrome (breeze) icons render black on black. Forcing the
  # KDE platform theme makes them read the Catppuccin palette, widget style and
  # icon theme from ~/.config/kdeglobals instead (see home/dolphin.nix).
  # QT_QPA_PLATFORMTHEME stays qt6ct for every other Qt app.
  nixpkgs.overlays = [
    (final: prev: {
      kdePackages = prev.kdePackages // lib.genAttrs
        [ "dolphin" "gwenview" "ark" "kdf" ]
        (name: final.symlinkJoin {
          inherit name;
          paths = [ prev.kdePackages.${name} ];
          nativeBuildInputs = [ final.makeWrapper ];
          postBuild = ''
            for bin in $out/bin/*; do
              wrapProgram "$bin" --set QT_QPA_PLATFORMTHEME kde
            done
          '';
        });
    })
  ];

  services.displayManager.enable = true;
  services.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "niri";

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
    kdePackages.kded
    solidUiServer
  ];
  # D-Bus activates kded6 on demand when Dolphin asks for an unlock prompt.
  services.dbus.packages = [ pkgs.kdePackages.kded ];

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
