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
    "${modDir}/hardware/btrfs.nix"
    "${modDir}/hardware/ssd.nix"
    "${modDir}/hardware/power-management/system76.nix"
    "${modDir}/docker.nix"
    "${modDir}/nix-quick-update"
    "${modDir}/wireguard.nix"

    # Desktop env
    "${modEnvironments}/hyprland"

    # Basic apps
    "${modDesktop}"
    "${modDesktop}/virt.nix"
    "${modDesktop}/gaming/default.nix"

    # Desktop Additionals
    "${modDev}"
    "${modDev}/universidad.nix"
  ];
}
