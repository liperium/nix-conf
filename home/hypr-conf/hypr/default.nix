{ config, pkgs, ... }:

{
    home.file = {
        "hypr/hyprland.conf".source = ./hyprland.conf;
        "hypr/macchiato.conf".source = ./macchiato.conf;
        "hypr/scripts/waybar/start.sh".source = ./scripts/waybar/start.sh;
    };
    wayland.windowManager.hyprland = {
        # Whether to enable Hyprland wayland compositor
        enable = true;
        # The hyprland package to use
        package = pkgs.hyprland;
        # Whether to enable XWayland
        xwayland.enable = true;
    }
}