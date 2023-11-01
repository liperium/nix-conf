let
  modDir = ../../modules;
  modDesktop = ../../modules/desktop;
  modEnvironments = ../../modules/desktop/environment;
  currentDir = ./.;
  godotMonoTesting = ../../pkgs/godot/4/mono;
in {
  imports = [
    # Base
    "${modDir}/base.nix"
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
    "${modDesktop}/dev"
    "${modDesktop}/godot-mono.nix"
    "${modDesktop}/universidad.nix"
  ];
}
