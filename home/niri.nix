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
}
