{ config
, pkgs
, hyprMonitor
, inputs
, ...
}:


{
  imports = [
    # Desktop
    ./desktop.nix
    ./console.nix
    ./hyprland/default.nix
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      icon-theme = "Papirus-Dark";
    };
  };

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      config.font = wezterm.font 'JetBrainsMono Nerd Font Propo'
    '';
  };

}
