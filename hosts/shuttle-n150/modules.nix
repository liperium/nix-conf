let
  modDir = ../../modules;
in
{
  imports = [
    # Base
    "${modDir}"
    "${modDir}/docker.nix"
  ];
}
