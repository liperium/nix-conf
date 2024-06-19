{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Btrfs special configs for apps
  virtualisation.docker = {
    storageDriver = "btrfs";
  };
}
