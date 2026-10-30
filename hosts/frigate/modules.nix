let
  modDir = ../../modules;
  modDesktop = ../../modules/desktop;
  modDev = ../../modules/desktop/dev;
  modEnvironments = ../../modules/desktop/environment;
  currentDir = ./.;
in
{
  imports = [
    # Base
    "${modDir}"

    # Additional System
    "${modDir}/hardware/ssd.nix"

    "${modDir}/wireguard.nix"
    "${modDir}/docker.nix"
    "${modDesktop}/printer.nix"
    "${currentDir}/wireguard.nix"

    # Desktop env
    "${modEnvironments}/niri"

    # Basic apps
    "${modDesktop}"
    "${modDesktop}/kdeconnect"
    "${modDesktop}/gaming"
    "${modDesktop}/virt.nix"

    # Desktop Additionals
    "${modDev}"
    "${modDev}/mapgears.nix"
    "${modDev}/universidad.nix"
  ];
}
