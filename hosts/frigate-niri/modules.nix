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
    ../frigate/wireguard.nix

    # Desktop env
    "${modEnvironments}/niri"

    # Basic apps
    "${modDesktop}"
    "${modDesktop}/kdeconnect"

    # Desktop Additionals
    "${modDev}"
    "${modDev}/universidad.nix"
  ];
}
