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
    #"${currentDir}/conservationmode"

    # Additional System
    "${modDir}/hardware/ssd.nix"
    "${modDir}/docker.nix"

    "${modDir}/wireguard.nix"
    "${modDir}/nix-quick-update"

    # Desktop env
    "${modEnvironments}/hyprland"

    # Basic apps
    "${modDesktop}"
    #"${modDesktop}/virt.nix"
    "${modDesktop}/gaming"

    # Desktop Additionals
    "${modDev}"
    "${modDev}/universidad.nix"
  ];
}
