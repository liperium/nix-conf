{ pkgs, inputs, hyprMonitor, ... }:

{
  imports = [
    ./niri-conf.nix
    ../dolphin.nix
    ../noctalia.nix
    ../hyprland/hypridle
  ];

  home.packages = with pkgs; [
    brightnessctl
    unstable.niri
  ];

  programs.foot = {
    enable = true;
    settings = {
      main = {
        shell = "fish";
        font = "JetBrainsMono Nerd Font:size=12";
      };
      colors = {
        alpha = 0.9;
      };
    };
  };
}
