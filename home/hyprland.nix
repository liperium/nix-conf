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
    ./hyprland/default.nix
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
      colors-dark = {
        alpha = 0.9;
      };
    };
  };

}
