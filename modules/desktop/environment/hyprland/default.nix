{ config, pkgs, lib, ... }:

{
  # Enable the X11 windowing system - Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "alt-intl";
    };

    displayManager = {
      #autoLogin.enable = true;
      #autoLogin.user = "liperium";
      #gdm = {
      #enable = true;
      #wayland = true;
      #};
    };
  };
  # BC of autologin - https://github.com/NixOS/nixpkgs/issues/103746
  #systemd.services."getty@tty1".enable = false;
  #systemd.services."autovt@tty1".enable = false;

  # Enable Hyprland - Need it here + home-manager
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  hardware = {
    opengl.enable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; #Ozone/discord/wayland
  environment.sessionVariables.GTK_THEME = "Catppuccin-Mocha-Standard-Mauve-Dark";
  environment.systemPackages = with pkgs; [
    kitty
    libsecret
    #polkit_gnome
    kdePackages.polkit-qt-1
    kdePackages.polkit-kde-agent-1
    kdePackages.kwallet
    kdePackages.kwallet-pam

    waybar # Top status bar # Home
    wlogout # Home
    networkmanagerapplet

    mako # Notifications # Home
    libnotify # Required by mako

    #swww # Wallpaper server # Home
    hyprpaper # Wallpaper server # Home

    pulseaudio
    killall # Restart processes
    pavucontrol # Audio panel

    grimblast # Screenshots
    #gnome.nautilus # File explorer
    kdePackages.dolphin
    #gnome.eog # Image viewer

    #xwaylandvideobridge #not working... works for 5s
    #kdeconnect #not working???
  ];
  security.polkit.enable = true;

  services.gvfs.enable = true; # Mount, trash, and other functionalities

  # Enable a keyring

  #programs.seahorse.enable = true;
  #services.gnome.gnome-keyring.enable = true;
  #security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.gdm.kwallet.enable = true;

  # Portal to make it easy
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    kdePackages.xdg-desktop-portal-kde
    xdg-desktop-portal-hyprland
  ];

  # Sound stuff
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  systemd = {
    #user.services.polkit-gnome-authentication-agent-1 = {
    #  description = "polkit-gnome-authentication-agent-1";
    #  wantedBy = [ "graphical-session.target" ];
    #  wants = [ "graphical-session.target" ];
    #  after = [ "graphical-session.target" ];
    #  serviceConfig = {
    #      Type = "simple";
    #      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    #      Restart = "on-failure";
    #      RestartSec = 1;
    #      TimeoutStopSec = 10;
    #    };
    #};
    #user.services.kwallet-pam-init-1 = {
    #  description = "Launches kwallet";
    #  wantedBy = [ "graphical-session.target" ];
    #  wants = [ "graphical-session.target" ];
    #  after = [ "graphical-session.target" ];
    #  serviceConfig = {
    #      Type = "simple";
    #      ExecStart = "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init";
    #      Restart = "on-failure";
    #      RestartSec = 1;
    #      TimeoutStopSec = 10;
    #    };    
    #};
  };
}
