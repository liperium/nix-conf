let
  modDir = ../../modules;
  modDesktop = ../../modules/desktop;
  currentDir = ./.;
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
      
      # Desktop env
      "${modDesktop}/default.nix"
      "${modDesktop}/plasma.nix"
      "${modDesktop}/godot-mono.nix"

      # Desktop Additionals
      "${modDesktop}/coding.nix"
    ];
}
