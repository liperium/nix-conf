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

      # Additional System
      "${modDir}/docker.nix"
      "${modDir}/dual-boot.nix"
      
      # Desktop env
      "${modDesktop}/default.nix"
      "${modDesktop}/plasma.nix"

      # Desktop Additionals
      "${modDesktop}/coding.nix"
      "${modDesktop}/gaming/default.nix"
      "${modDesktop}/godot-mono.nix"
      "${modDesktop}/universidad.nix"
    ];
}