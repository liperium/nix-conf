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
      autoLogin.enable = true;
      autoLogin.user = "liperium";
      gdm = {
        enable = true;
        wayland = true;
      };
    };
  };
  # BC of autologin - https://github.com/NixOS/nixpkgs/issues/103746
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Enable Hyprland - Need it here + home-manager
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  hardware = {
    opengl.enable = true;
  };

  environment.sessionVariables.GTK_THEME = "Catppuccin-Mocha-Standard-Mauve-Dark";
  environment.systemPackages = with pkgs; [
    kitty
    libsecret
    polkit_gnome
    
    waybar # Top status bar # Home
    wlogout # Home
    networkmanagerapplet

    mako # Notifications # Home
    libnotify # Required by mako

    #swww # Wallpaper server # Home

    pulseaudio
    killall # Restart processes
    pavucontrol # Audio panel

    grimblast # Screenshots
    gnome.nautilus # File explorer
    gnome.eog # Image viewer

    #xwaylandvideobridge #not working... works for 5s
    #kdeconnect #not working???
  ];
  security.polkit.enable = true;

  services.gvfs.enable = true; # Mount, trash, and other functionalities

  programs.file-roller.enable = true; # archive manager

  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  # Portal to make it easy
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ 
    xdg-desktop-portal-gtk
    #xdg-desktop-portal-hyprland already applied?
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
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
    };
  };
}
