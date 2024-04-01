{ config, pkgs, ... }:

{
  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
  xdg.configFile."hypr/macchiato.conf".source = ./macchiato.conf;
  xdg.configFile."hypr/scripts/waybar/start.sh".source = ./scripts/waybar/start.sh;

  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    package = pkgs.hyprland;
    # Whether to enable XWayland
    xwayland.enable = true;
  };
}
