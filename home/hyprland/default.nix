{ config, pkgs, hyprMonitor, ... }:

{
  imports = [
    ./hyprland-conf.nix
    ./hypridle
    ../noctalia.nix
    ../dolphin.nix
  ];

  xdg.configFile."hypr/macchiato.conf".source = ./macchiato.conf;

  home.packages = with pkgs; [
    brightnessctl
    hyprland-qtutils
    hyprshot
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    systemd.enable = false;
    xwayland.enable = true;
  };
}
