{ pkgs, lib, inputs, system, ... }:

let
  # Read-only commands safe to run without a permission prompt, everywhere.
  globalAllowPatterns = [
    "Bash(rtk grep *)"
    "Bash(rtk git status*)"
    "Bash(rtk git diff*)"
    "Bash(rtk git log*)"
    "Bash(rtk ls *)"
    "Bash(rtk find *)"
    "Bash(rtk proxy cat*)"
    "Bash(nix eval *)"
  ];
  staticClaudeMd = pkgs.writeText "claude-md-header" ''
    # User-level Claude Instructions

    ## Running Code and CLI Tools

    This is a NixOS system. NEVER invoke interpreters or tools directly (python3, node, cargo, pip, etc.).
    Binaries only exist in PATH if declared in the NixOS configuration.

    - For one-off commands: `nix-shell -p <package> --run "<command>"`
    - For projects with a `flake.nix` devShell: `nix develop -c <command>`
    - For projects use devenv.
    - For projects with `.envrc` (direnv active): just run commands normally after `direnv allow`
    - Never use: python, python3, pip, node, cargo directly — always wrap with nix-shell or nix develop

    ## Communication

    Ponytail skill is active by default (lazy/minimal-diff mode). Use `/ponytail lite|full|ultra` to adjust, or "stop ponytail" to disable.
    (Caveman skill disabled by default. Use `/caveman` to enable ultra-compressed mode if desired.)
  '';

  realClaude = inputs.claude-code.packages.${system}.default;
  claudeWrapped = pkgs.symlinkJoin {
    name = "claude-with-plugins";
    paths = [ realClaude ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude \
        --prefix PATH : ${pkgs.nodejs}/bin \
        --prefix PATH : ${pkgs.python3}/bin \
        --prefix PATH : ${pkgs.unstable.rtk}/bin \
        --prefix LD_LIBRARY_PATH : ${pkgs.stdenv.cc.cc.lib}/lib \
        --prefix LD_LIBRARY_PATH : ${pkgs.zlib}/lib
    '';
  };
in
{
  home.packages = [ claudeWrapped pkgs.unstable.rtk ];

  # Sync CLAUDE.md: write static header, then auto-inject RTK instructions from binary
  home.activation.syncClaudeMd = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.claude"
    $DRY_RUN_CMD cp ${staticClaudeMd} "$HOME/.claude/CLAUDE.md"
    $DRY_RUN_CMD chmod u+w "$HOME/.claude/CLAUDE.md"
    $DRY_RUN_CMD ${pkgs.unstable.rtk}/bin/rtk init -g --claude-md
  '';

  # Install caveman + ponytail plugins, disable caveman, enable ponytail by default
  home.activation.installClaudePlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    CLAUDE=${claudeWrapped}/bin/claude
    if [ ! -d "$HOME/.claude/plugins/marketplaces/caveman" ]; then
      $DRY_RUN_CMD $CLAUDE plugin marketplace add JuliusBrussee/caveman 2>/dev/null || true
      $DRY_RUN_CMD $CLAUDE plugin install caveman@caveman 2>/dev/null || true
    fi
    if [ ! -d "$HOME/.claude/plugins/marketplaces/ponytail" ]; then
      $DRY_RUN_CMD $CLAUDE plugin marketplace add DietrichGebert/ponytail 2>/dev/null || true
      $DRY_RUN_CMD $CLAUDE plugin install ponytail@ponytail 2>/dev/null || true
    fi
    $DRY_RUN_CMD $CLAUDE plugin disable caveman@caveman 2>/dev/null || true
    $DRY_RUN_CMD $CLAUDE plugin enable ponytail@ponytail 2>/dev/null || true
  '';

  # Merge the read-only allowlist into ~/.claude/settings.json without touching anything else in it
  home.activation.mergeClaudeAllowlist = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    SETTINGS="$HOME/.claude/settings.json"
    mkdir -p "$HOME/.claude"
    [ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
    ${pkgs.jq}/bin/jq \
      --argjson allow '${builtins.toJSON globalAllowPatterns}' \
      '.permissions.allow = ((.permissions.allow // []) + $allow | unique)' \
      "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
  '';
}
