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
      #icon-theme = "Papirus-Dark";
    };
  };

  # programs.wezterm = {
  #   enable = true;
  #   extraConfig = ''
  #     local config = wezterm.config_builder()
  #     config.font = wezterm.font 'JetBrainsMono Nerd Font Propo'
  #     config.window_background_opacity = 0.85
  #     config.hide_tab_bar_if_only_one_tab = true
  #     config.default_prog = { 'fish' }
  #     return config
  #   '';
  # };
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
