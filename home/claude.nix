{ pkgs, lib, inputs, system, ... }:

let
  realClaude = inputs.claude-code.packages.${system}.default;
  claudeWrapped = pkgs.symlinkJoin {
    name = "claude-with-plugins";
    paths = [ realClaude ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude \
        --prefix PATH : ${pkgs.nodejs}/bin \
        --prefix PATH : ${pkgs.python3}/bin \
        --prefix LD_LIBRARY_PATH : ${pkgs.stdenv.cc.cc.lib}/lib \
        --prefix LD_LIBRARY_PATH : ${pkgs.zlib}/lib \
        --run 'MEMPALACE_VENV="$HOME/.local/share/mempalace-env-${pkgs.python3.version}"; [ -f "$MEMPALACE_VENV/bin/mempalace" ] || (${pkgs.python3}/bin/python3 -m venv "$MEMPALACE_VENV" && "$MEMPALACE_VENV/bin/pip" install --quiet mempalace); export PATH="$MEMPALACE_VENV/bin:$PATH"'
    '';
  };
in
{
  home.packages = [ claudeWrapped ];

  # User-level Claude instructions (apply to all projects)
  home.file.".claude/CLAUDE.md".text = ''
    # User-level Claude Instructions

    ## Running Code and CLI Tools

    This is a NixOS system. NEVER invoke interpreters or tools directly (python3, node, cargo, pip, etc.).
    Binaries only exist in PATH if declared in the NixOS configuration.

    - For one-off commands: `nix-shell -p <package> -c "<command>"`
    - For projects with a `flake.nix` devShell: `nix develop -c <command>`
    - For projects with `.envrc` (direnv active): just run commands normally after `direnv allow`
    - Never use: python, python3, pip, node, cargo directly — always wrap with nix-shell or nix develop

    ## Communication

    Caveman skill is available. Use `/caveman` to enable ultra-compressed mode.
  '';

  # Install caveman Claude plugin if not already present
  home.activation.installCavemanPlugin = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.claude/plugins/marketplaces/caveman" ]; then
      $DRY_RUN_CMD ${claudeWrapped}/bin/claude install caveman --market caveman --yes 2>/dev/null || true
    fi
  '';
}
