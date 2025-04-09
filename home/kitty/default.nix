{ config, pkgs, ... }:

{
  home.file = {
    ".config/kitty/kitty.conf".source = ./kitty.conf;
  };
  home.sessionVariables = {
    TERMINAL = "kitty";
  };
  home.packages = with pkgs; [ kitty ];
}
