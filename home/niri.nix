{ ... }:

{
  imports = [
    ./desktop.nix
    ./niri/default.nix
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}
