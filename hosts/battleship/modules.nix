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
    "${modDesktop}"
    "${modEnvironments}/plasma"

    # Desktop Additionals
    "${modDev}"
    "${modDev}/godot4-mono"
    "${modDev}/universidad.nix"
    "${modDesktop}/gaming/default.nix"
  ];
}
