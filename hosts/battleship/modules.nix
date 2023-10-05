let
  modDir = ../../modules;
  modDesktop = ../../modules/desktop;
  currentDir = ./.;
  protonup-rsDir = /home/liperium/Programming/Personnal/Protonup-rs;
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
      "${protonup-rsDir}/default.nix"
    ];
}
