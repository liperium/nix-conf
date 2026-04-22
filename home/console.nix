{ pkgs, ... }:

let
  mempalaceBin = pkgs.writeShellScriptBin "mempalace" ''
    venv="$HOME/.local/share/mempalace-env-${pkgs.python3.version}"
    [ -f "$venv/bin/mempalace" ] || (${pkgs.python3}/bin/python3 -m venv "$venv" && "$venv/bin/pip" install --quiet mempalace)
    exec "$venv/bin/mempalace" "$@"
  '';
in
{
  imports = [
    # Everywhere
    ./zsh
    ./helix
    ./zellij
    ./claude.nix
  ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = "liperium";
  home.homeDirectory = "/home/liperium";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    fastfetch
    dconf
    mempalaceBin
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
        fish -c '
          if git rev-parse --is-inside-work-tree &>/dev/null
            git fetch --quiet
            commandline -f repaint
          end
        ' &
      end    '';
  };
  programs.oh-my-posh.enableFishIntegration = false;
}
