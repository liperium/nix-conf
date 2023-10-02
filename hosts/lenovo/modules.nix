let
  modDir = ../../modules;
  modDesktop = ../../modules/desktop;
in
{
  imports =
    [ # Include the results of the hardware scan.
      "${modDir}/base.nix"
      
      "${modDesktop}/base.nix"
      "${modDesktop}/plasma.nix"
      "${modDesktop}/coding.nix"
    ];
}
