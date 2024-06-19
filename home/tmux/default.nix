{ config, pkgs, ... }:

{
  home.file = {
    ".tmux.conf".source = ./.tmux.conf;
  };
  home.packages = with pkgs; [ tmux ];
}
