let
  modDir = ../../modules;
  modDesktop = ../../modules/desktop;
  currentDir = ./.;
  godotMonoTesting = ../../pkgs/godot/4/mono;
in
{
  imports =
    [
      # Base
      "${modDir}/base.nix"
      "${currentDir}/conservationmode.nix"

      # Additional System
      "${modDir}/docker.nix"
      "${modDir}/dual-boot.nix"
      "${modDir}/wireguard.nix"
      
      # Desktop env
      "${modDesktop}/default.nix"
      "${modDesktop}/plasma.nix"
      
      # Desktop Additionals
      "${modDesktop}/coding.nix"
      "${modDesktop}/godot-mono.nix"
      "${modDesktop}/universidad.nix"
    ];
}
