{ ... }:

{
  home.file.".cursor/rules/nixos-shell.mdc".text = ''
    ---
    description: NixOS shell wrapping for all terminal commands
    alwaysApply: true
    ---

    ## Running Code and CLI Tools

    This is a NixOS system. NEVER invoke interpreters or tools directly (python3, node, cargo, pip, etc.).
    Binaries only exist in PATH if declared in the NixOS configuration.

    - For one-off commands: `nix-shell -p <package> --run "<command>"`
    - For projects with a `flake.nix` devShell: `nix develop -c <command>`
    - For projects with `.envrc` (direnv active): run commands normally after `direnv allow`
    - Never use: python, python3, pip, node, cargo directly — always wrap with nix-shell or nix develop

    ### Examples

    ```bash
    nix-shell -p gradle --run "gradle build"
    nix-shell -p git gh --run "gh pr list"
    nix develop -c cargo test
    ```
  '';
}
