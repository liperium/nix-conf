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

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  hardware = {
    opengl.enable = true;
  };

  #wayland.windowManager.hyprland.settings = {
  #};

  environment.systemPackages = with pkgs; [
    alacritty
    kitty
    libsecret
    
    libsForQt5.dolphin
    
    waybar # Top status bar

    mako # Notifications
    libnotify # Required by mako

    swww # Wallpaper server

    pulseaudio
    killall # Restart processes
    pavucontrol # Audio panel

    grimblast # Screenshots
    #xfce.thunar
    #hyprpicker # Color picker, doesn't work?

    rofi-wayland # App Search
  ];

  # Portal to make it easy
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

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
