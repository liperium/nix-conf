{ config, pkgs, hyprMonitor, ... }:

{
  imports = [ ./hyprconf.nix ];
  #xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
  xdg.configFile."hypr/macchiato.conf".source = ./macchiato.conf;
  #xdg.configFile."hypr/scripts/waybar/start.sh".source = ./scripts/waybar/start.sh;

  home.packages = with pkgs; [
    # For audio keyboard shortcuts (pactl is included in pulseaudio)
    playerctl # For play/pause/next/previous
    brightnessctl
    # Theming
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    kdePackages.qt6ct
    (catppuccin-kvantum.override {
      accent = "mauve";
      variant = "mocha";
    })

    # Others
    hyprland-qtutils
    hyprshot
  ];

  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    # Disable them because managed by NixOs
    package = null;
    portalPackage = null;
    systemd.enable = false;
    # Whether to enable XWayland
    xwayland.enable = true;

  };
}
