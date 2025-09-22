{ config, pkgs, ... }:

{
  home.file = {
    ".config/rofi/config.rasi".source = ./config.rasi;
    ".local/share/rofi/themes/catppuccin-macchiato-liperium.rasi".source = ./catppuccin-macchiato-liperium.rasi;
  };

  home.packages = with pkgs; [

    (rofi.override {
      plugins = [
        rofi-emoji
        rofi-games
        rofi-bluetooth
        rofi-network-manager
        rofi-calc
        rofi-vpn
      ];
    })

    # rofi-emoji
    # rofi-network-manager
    # rofi-bluetooth
  ];
}
