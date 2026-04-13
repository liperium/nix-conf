{ config, pkgs, inputs, system, ... }:

let
  realClaude = inputs.claude-code.packages.${system}.default;
  mempalaceBin = pkgs.writeShellScriptBin "mempalace" ''
    venv="$HOME/.local/share/mempalace-env-${pkgs.python3.version}"
    [ -f "$venv/bin/mempalace" ] || (${pkgs.python3}/bin/python3 -m venv "$venv" && "$venv/bin/pip" install --quiet mempalace)
    exec "$venv/bin/mempalace" "$@"
  '';
  claudeWrapped = pkgs.symlinkJoin {
    name = "claude-with-plugins";
    paths = [ realClaude ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude \
        --prefix PATH : ${pkgs.nodejs}/bin \
        --prefix PATH : ${pkgs.python3}/bin \
        --prefix LD_LIBRARY_PATH : ${pkgs.stdenv.cc.cc.lib}/lib \
        --run 'MEMPALACE_VENV="$HOME/.local/share/mempalace-env-${pkgs.python3.version}"; [ -f "$MEMPALACE_VENV/bin/mempalace" ] || (${pkgs.python3}/bin/python3 -m venv "$MEMPALACE_VENV" && "$MEMPALACE_VENV/bin/pip" install --quiet mempalace); export PATH="$MEMPALACE_VENV/bin:$PATH"'
    '';
  };
in
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
    claudeWrapped
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
