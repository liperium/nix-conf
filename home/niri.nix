{ config
, pkgs
, hyprMonitor
, inputs
, ...
}:

{
  imports = [
    ./desktop.nix
    ./console.nix
    ./niri/default.nix
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
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
