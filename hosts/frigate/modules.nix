let
  modDir = ../../modules;
  modDesktop = ../../modules/desktop;
  modDesktop = ../../modules/desktop/dev;
  modEnvironments = ../../modules/desktop/environment;
  currentDir = ./.;
in {
  imports = [
    # Base
    "${modDir}/default.nix"
    "${currentDir}/conservationmode"

    # Additional System
    "${modDir}/docker.nix"
    "${modDir}/dual-boot.nix"
    "${modDir}/wireguard.nix"

    # Desktop env
    "${modEnvironments}/plasma"

    # Basic apps
    "${modDesktop}/default.nix"

    # Desktop Additionals
    "${modDev}"
    "${modDev}/godot4-mono"
    "${modDesktop}/universidad.nix"
  ];
}
