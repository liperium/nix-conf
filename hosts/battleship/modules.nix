let
  modDir = ../../modules;
  modDesktop = ../../modules/desktop;
  modDev = ../../modules/desktop/dev;
  modEnvironments = ../../modules/desktop/environment;
in {
  imports = [
    # Base
    "${modDir}/default.nix"

    # Additional System
    "${modDir}/docker.nix"
    "${modDir}/dual-boot.nix"

    # Desktop env
    "${modDesktop}/default.nix"
    "${modEnvironments}/plasma"

    # Desktop Additionals
    "${modDev}/default.nix"
    "${modDev}/godot4-mono"
    "${modDesktop}/gaming/default.nix"
    "${modDesktop}/dev/universidad.nix"
  ];
}
