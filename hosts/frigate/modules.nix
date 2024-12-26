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
    "${currentDir}/conservationmode"

    # Additional System
    "${modDir}/hardware/btrfs.nix"
    "${modDir}/hardware/ssd.nix"
    "${modDir}/hardware/dual-boot.nix"

    "${modDir}/docker.nix"

    "${modDir}/wireguard.nix"
    "${modDir}/nix-quick-update"
    "${modDir}/nix-flake-template"

    # Desktop env
    "${modEnvironments}/hyprland"
    #"${modEnvironments}/plasma"
    #"${modEnvironments}/cosmic"
    "${modDir}/hardware/power-management/system76.nix"

    # Basic apps
    "${modDesktop}"
    "${modDesktop}/virt.nix"
    "${modDesktop}/gaming"

    # Desktop Additionals
    "${modDev}"
    #"${modDev}/godot4-mono"
    "${modDev}/universidad.nix"
  ];
}
