let
  modDir = ../../modules;
in
{
  imports = [
    # Base
    "${modDir}"

    "${modDir}/nix-quick-update"
  ];
}
