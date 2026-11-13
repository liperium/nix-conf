{ pkgs, lib, inputs, system, ... }:

let
  # Read-only commands safe to run without a permission prompt, everywhere.
  globalAllowPatterns = [
    "Bash(grep *)"
    "Bash(git status*)"
    "Bash(git diff*)"
    "Bash(git log*)"
    "Bash(ls *)"
    "Bash(find *)"
    "Bash(nix eval *)"
    "Bash(go test*)"
    "Bash(go build*)"
    "Bash(go vet*)"
    "Bash(journalctl *)"
    "Bash(bootctl list *)"
    "Bash(jenkins-get *)"
  ];
  # Always prompt for these, even in auto mode (ask rules beat allow rules and the classifier).
  globalAskPatterns = [
    "Bash(tsh)"
    "Bash(tsh *)"
  ];
  # Catches tsh anywhere in the command (nix-shell --run, bash -c, pipes...). Word match,
  # so it over-matches e.g. `echo tsh`; that only costs an extra prompt.
  askTshHook = pkgs.writeShellScript "claude-ask-tsh" ''
    if ${pkgs.jq}/bin/jq -r '.tool_input.command // ""' | ${pkgs.gnugrep}/bin/grep -qw tsh; then
      echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"tsh command: always ask"}}'
    fi
  '';
  # Read-only Jenkins REST access: GET only (no -X/-d passthrough), fixed host, no redirects.
  # The token is read from $JENKINS_API here and fed to curl on stdin, so it never shows
  # in a command line, ps or output. Paths that can expose secrets are refused even on GET.
  jenkinsGet = pkgs.writeShellScriptBin "jenkins-get" ''
    set -euo pipefail
    path=''${1:?usage: jenkins-get <path>, e.g. job/<name>/lastBuild/consoleText}
    if [[ $path =~ (credential|script|manage|configure|systemInfo|[Ee]nvVars|(^|/)cli(/|$)|config\.xml|\.\.) ]]; then
      echo "jenkins-get: refused path: $path" >&2
      exit 2
    fi
    printf 'user = "%s:%s"\n' "''${JENKINS_USER:?set JENKINS_USER}" "''${JENKINS_API:?set JENKINS_API}" \
      | ${pkgs.curl}/bin/curl -fsS --globoff --proto =https -K - "https://jenkins3.mapgears.com/''${path#/}"
  '';
  # Refuses Bash commands that name $JENKINS_API or dump the environment. Guards against
  # accidents only: Claude runs as you, so anything jenkins-get can read, Claude can too.
  # The real limit is the token's own Jenkins permissions.
  guardJenkinsHook = pkgs.writeShellScript "claude-guard-jenkins" ''
    if ${pkgs.jq}/bin/jq -r '.tool_input.command // ""' \
      | ${pkgs.gnugrep}/bin/grep -Eq 'JENKINS_API|printenv|/environ|export -p|declare -[a-z]*x|(^|[;&|(]\s*)(env|set)\s*($|[;&|)])'; then
      echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"could expose JENKINS_API; use jenkins-get"}}'
    fi
  '';
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
    - Never start a full system closure build (`nixos-rebuild switch/build`, or building a host's
      `system.build.toplevel`) without asking first. Build only the specific package/flake output
      you need; deploys are the user's call.
    - Claude Code / MCP / plugin config lives declaratively in `~/nix-conf` (see `home/claude.nix`).
      Prefer editing that config over imperative `claude mcp add/remove` or plugin install/uninstall
      commands, then ask the user to rebuild.

    ## Planning

    For a change touching 3+ files or a new feature area, share a short plan (files to touch, order
    of work, how you'll verify) and wait for approval before editing.

    ## Verification

    Don't declare a fix done from reading code alone. Show the command you ran and its real output.
    If you can't verify something (e.g. it needs a GUI or a browser), say UNVERIFIED explicitly.

    ## Debugging Discipline

    Before proposing a fix for an environment/config issue, confirm the actual state (filesystem
    type, hardware, existing entries) instead of assuming a default.

    ## Communication

    Ponytail skill is active by default (lazy/minimal-diff mode). Use `/ponytail lite|full|ultra` to adjust, or "stop ponytail" to disable.
    (Caveman skill disabled by default. Use `/caveman` to enable ultra-compressed mode if desired.)
    Never label code comments "ponytail:" (or with any other skill name); write limitations as plain comments.

    ## Notes and Docs

    Every note or doc the user asks for goes in `~/Documents/Notes` (a tolaria vault), never in
    `~/Documents/Nextcloud/MapGears`. Start each note with YAML frontmatter (`type: Reference`,
    `status: Reference`, `belongs_to: "[[MapGears]]"`), then a `# <Title>` line. For the Python 3.14
    migration, `tracking-python.md` and `workflow-python314.md` in that folder are canonical; the
    Nextcloud copies are stale.
  '';

  realClaude = inputs.claude-code.packages.${system}.default;
  claudeWrapped = pkgs.symlinkJoin {
    name = "claude-with-plugins";
    paths = [ realClaude ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    # --suffix, not --prefix: fallbacks only, so a project's devenv/direnv
    # python and node still win inside Claude's shell. No LD_LIBRARY_PATH —
    # it leaked into project envs (glibc mismatches) and only mempalace/graphify
    # needed it.
    postBuild = ''
      wrapProgram $out/bin/claude \
        --suffix PATH : ${pkgs.nodejs}/bin \
        --suffix PATH : ${pkgs.python3}/bin
    '';
  };
in
{
  home.packages = [ claudeWrapped pkgs.unstable.uv jenkinsGet ];

  home.file.".claude/skills/arc-diff/SKILL.md".source = ./claude-skills/arc-diff/SKILL.md;

  # Sync CLAUDE.md: write static header
  home.activation.syncClaudeMd = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.claude"
    $DRY_RUN_CMD cp ${staticClaudeMd} "$HOME/.claude/CLAUDE.md"
    $DRY_RUN_CMD chmod u+w "$HOME/.claude/CLAUDE.md"
  '';

  # Merge the read-only allowlist into ~/.claude/settings.json without touching anything else in it
  home.activation.mergeClaudeAllowlist = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    SETTINGS="$HOME/.claude/settings.json"
    mkdir -p "$HOME/.claude"
    [ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
    ${pkgs.jq}/bin/jq \
      --argjson allow '${builtins.toJSON globalAllowPatterns}' \
      --argjson ask '${builtins.toJSON globalAskPatterns}' \
      '.permissions.allow = ((.permissions.allow // []) + $allow | map(select(startswith("Bash(rtk ") | not)) | unique)
       | .permissions.ask = ((.permissions.ask // []) + $ask | unique)
       | .hooks.PreToolUse = ([(.hooks.PreToolUse // [])[] | select(tostring | test("claude-ask-tsh|claude-guard-jenkins") | not)]
           + [{matcher: "Bash", hooks: [{type: "command", command: "${askTshHook}"}, {type: "command", command: "${guardJenkinsHook}"}]}])' \
      "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
  '';
}
