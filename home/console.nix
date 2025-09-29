{ config, pkgs, inputs, ... }:


{
  imports = [
    # Everywhere
    ./zsh
    ./helix
    ./zellij
  ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = "liperium";
  home.homeDirectory = "/home/liperium";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    fastfetch
    dconf
    # needed for ark archives
    p7zip
    #rar
    # From default config modules 
    #Basic Needs
    vulkan-tools
  ];
  #Direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.fish = {
    enable = true;
  };
  programs.oh-my-posh.enableFishIntegration = false;
}
