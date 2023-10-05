let
  modDir = ../../modules;
  modDesktop = ../../modules/desktop;
  currentDir = ./.;
in
{
  imports =
    [ # Include the results of the hardware scan.
      "${modDir}/base.nix"
      "${modDir}/docker.nix"
      "${modDir}/dual-boot.nix"
      
      "${modDesktop}/base.nix"
      "${modDesktop}/plasma.nix"
      "${modDesktop}/coding.nix"
    ];
}
