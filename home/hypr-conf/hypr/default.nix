{ config, pkgs, ... }:

{
  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
  xdg.configFile."hypr/macchiato.conf".source = ./macchiato.conf;
  #xdg.configFile."hypr/scripts/waybar/start.sh".source = ./scripts/waybar/start.sh;

  home.packages = with pkgs; [
    # For audio keyboard shortcuts (pactl is included in pulseaudio)
    playerctl # For play/pause/next/previous
    brightnessctl
    libsForQt5.qt5ct
    kdePackages.qt6ct
    hyprland-qtutils
  ];

  # wayland.windowManager.hyprland = {
  #   # Whether to enable Hyprland wayland compositor
  #   enable = true;
  #   # The hyprland package to use
  #   package = pkgs.hyprland;
  #   # Whether to enable XWayland
  #   xwayland.enable = true;
  # };
}
