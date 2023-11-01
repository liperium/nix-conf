let
  modDir = ../../modules;
  modDesktop = ../../modules/desktop;
  modEnvironments = ../../modules/desktop/environment;
  godotMonoTesting = ../../pkgs/godot/4/mono;
in {
  imports = [
    # Base
    "${modDir}/default.nix"

    # Additional System
    "${modDir}/docker.nix"
    "${modDir}/dual-boot.nix"

    # Desktop env
    "${modDesktop}/default.nix"
    "${modEnvironments}/plasma.nix"

    # Desktop Additionals
    "${modDesktop}/coding.nix"
    "${modDesktop}/gaming/default.nix"
    "${modDesktop}/godot-mono"
    "${modDesktop}/universidad.nix"
  ];
}
