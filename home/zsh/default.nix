{ config, pkgs, ... }:

{
  home.file = {
    ".config/omp/catppuccin_mocha.omp.json".source = ./catppuccin_mocha.omp.json;
    ".config/omp/zen.toml".source = ./zen.toml;
  };

  programs.zsh = {
    enable = true;
  };

  programs.oh-my-posh = {
    enable = true;
  };
}
