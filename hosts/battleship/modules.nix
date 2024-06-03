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
    "${modDir}/btrfs.nix"
    "${modDir}/docker.nix"
    #"${modDir}/dual-boot.nix" Using grub instead of systemd
    "${modDir}/nix-quick-update"
    #"${modDir}/wireguard.nix"

    # Desktop env
    "${modEnvironments}/hyprland"
    "${modEnvironments}/plasma"

    # Basic apps
    "${modDesktop}"
    "${modDesktop}/virt.nix"
    "${modDesktop}/gaming/default.nix"
    "${modDesktop}/kdeconnect"

    # Desktop Additionals
    "${modDev}"
    #"${modDev}/godot4-mono"
    "${modDev}/universidad.nix"
    #"${currentDir}/dummy-conservationmode"
  ];
}
