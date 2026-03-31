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
    claude-code
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
    # Git fetch on enter a git directory
    interactiveShellInit = ''
      function __git_fetch_on_cd --on-variable PWD
        if git rev-parse --is-inside-work-tree &>/dev/null
          git fetch --all --quiet &
        end
      end
    '';
  };
  programs.oh-my-posh.enableFishIntegration = false;
}
