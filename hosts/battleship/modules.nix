let
  modDir = ../../modules;
  modDesktop = ../../modules/desktop;
  modDev = ../../modules/desktop/dev;
  modEnvironments = ../../modules/desktop/environment;
in {
  imports = [
    # Base
    "${modDir}/default.nix"

    # Additional System
    "${modDir}/btrfs.nix"
    "${modDir}/docker.nix"
    "${modDir}/dual-boot.nix"
    "${modDir}/nix-quick-update"
    "${modDir}/btop-up"
    #"${modDir}/wireguard.nix"

    # Desktop env
    "${modEnvironments}/hyprland"

    # Basic apps
    "${modDesktop}"
    "${modDesktop}/virt.nix"
    "${modDesktop}/gaming/default.nix"

    # Desktop Additionals
    "${modDev}"
    #"${modDev}/godot4-mono"
    "${modDev}/universidad.nix"
    
  ];
}
