let
  modDir = ../../modules;
  modDesktop = ../../modules/desktop;
  modDev = ../../modules/desktop/dev;
  modEnvironments = ../../modules/desktop/environment;
  currentDir = ./.;
in {
  imports = [
    # Base
    "${modDir}"
    "${currentDir}/conservationmode"

    # Additional System
    "${modDir}/docker.nix"
    "${modDir}/dual-boot.nix"
    "${modDir}/wireguard.nix"
    "${modDir}/nix-quick-update"

    # Desktop env
    "${modEnvironments}/hyprland"

    # Basic apps
    "${modDesktop}"
    "${modDesktop}/virt.nix"

    # Desktop Additionals
    "${modDev}"
    #"${modDev}/godot4-mono"
    "${modDev}/universidad.nix"
  ];
}
