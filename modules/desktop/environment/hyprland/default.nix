{ config, pkgs, lib, ... }:

{
  # Enable the X11 windowing system - Configure keymap in X11
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "alt-intl";
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  # Enable Hyprland - Need it here + home-manager
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  hardware = {
    opengl.enable = true;
  };

  environment.systemPackages = with pkgs; [
    kitty
    #gnome.gnome-keyring # secrets manager
    libsecret
    
    waybar # Top status bar
    wlogout
    networkmanagerapplet

    mako # Notifications
    libnotify # Required by mako

    swww # Wallpaper server

    pulseaudio
    killall # Restart processes
    pavucontrol # Audio panel

    grimblast # Screenshots
    xfce.thunar # File explorer
    gnome.eog # Image viewer
    #hyprpicker # Color picker, doesn't work?
  ];
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  #Thunar services
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  programs.file-roller.enable = true; # archive manager

  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;

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


}
